let usersData = {};
const PASTEBIN_URL = 'https://pastebin.com/raw/QLYxihfk';

async function refreshData() {
    const refreshIcon = document.getElementById('refreshIcon');
    refreshIcon.style.animation = 'spin 1s linear infinite';
    
    try {
        const response = await fetch(PASTEBIN_URL);
        const data = await response.json();
        usersData = data;
        renderTable();
        updateLastSync();
        alert('✅ Data berhasil dimuat!');
    } catch (error) {
        alert('❌ Gagal memuat data!');
        console.error(error);
    }
    
    refreshIcon.style.animation = '';
}

function renderTable() {
    const tbody = document.getElementById('userTable');
    tbody.innerHTML = '';
    
    Object.entries(usersData).forEach(([key, user]) => {
        const row = document.createElement('tr');
        row.className = 'border-b border-purple-500/20 hover:bg-purple-600/20 transition-colors';
        
        const tierColor = user.tier === 'lifetime' || user.tier === 'vip' ? 'bg-purple-500' : 'bg-blue-500';
        const displayExpiry = user.expiry === '2099-12-31' ? 'lifetime' : user.expiry;
        
        row.innerHTML = `
            <td class="p-4 text-white font-medium">${user.user}</td>
            <td class="p-4">
                <span class="px-3 py-1 rounded-full text-xs font-semibold ${tierColor} text-white">
                    ${user.tier.toUpperCase()}
                </span>
            </td>
            <td class="p-4 text-purple-200">${displayExpiry}</td>
            <td class="p-4 text-right">
                <div class="flex gap-2 justify-end">
                    <button onclick="openEditModal('${key}')" class="px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-md transition-all">
                        ✏️ Edit
                    </button>
                    <button onclick="deleteUser('${key}')" class="px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white rounded-md transition-all">
                        🗑️
                    </button>
                </div>
            </td>
        `;
        
        tbody.appendChild(row);
    });
    
    document.getElementById('totalUsers').textContent = Object.keys(usersData).length;
}

function generateKey(username) {
    const random = Math.floor(Math.random() * 900000) + 100000;
    return `MORRIS-${username.toUpperCase()}${random}`;
}

function openAddModal() {
    document.getElementById('addModal').classList.add('active');
}

function closeAddModal() {
    document.getElementById('addModal').classList.remove('active');
    clearAddForm();
}

function toggleLifetime() {
    const checkbox = document.getElementById('lifetimeCheck');
    const expiryInput = document.getElementById('newExpiry');
    
    if (checkbox.checked) {
        expiryInput.value = '2099-12-31';
        expiryInput.disabled = true;
    } else {
        expiryInput.disabled = false;
    }
}

function addUser() {
    const username = document.getElementById('newUsername').value.trim();
    const tier = document.getElementById('newTier').value;
    const expiry = document.getElementById('newExpiry').value;
    
    if (!username) {
        alert('❌ Username harus diisi!');
        return;
    }
    
    if (!expiry) {
        alert('❌ Expiry date harus diisi!');
        return;
    }
    
    const key = generateKey(username);
    const today = new Date().toISOString().split('T')[0];
    
    usersData[key] = {
        user: username,
        tier: tier,
        expiry: expiry,
        status: 'active',
        hwid: 'UNBOUND',
        createdAt: today
    };
    
    renderTable();
    closeAddModal();
    alert('✅ User berhasil ditambahkan!');
}

function clearAddForm() {
    document.getElementById('newUsername').value = '';
    document.getElementById('newTier').value = 'vip';
    document.getElementById('newExpiry').value = '';
    document.getElementById('lifetimeCheck').checked = false;
    document.getElementById('newExpiry').disabled = false;
}

function openEditModal(key) {
    const user = usersData[key];
    
    document.getElementById('editKey').value = key;
    document.getElementById('editUsername').value = user.user;
    document.getElementById('editTier').value = user.tier;
    document.getElementById('editExpiry').value = user.expiry;
    
    document.getElementById('editModal').classList.add('active');
}

function closeEditModal() {
    document.getElementById('editModal').classList.remove('active');
}

function updateUser() {
    const key = document.getElementById('editKey').value;
    const username = document.getElementById('editUsername').value.trim();
    const tier = document.getElementById('editTier').value;
    const expiry = document.getElementById('editExpiry').value;
    
    if (!username || !expiry) {
        alert('❌ Semua field harus diisi!');
        return;
    }
    
    usersData[key].user = username;
    usersData[key].tier = tier;
    usersData[key].expiry = expiry;
    
    renderTable();
    closeEditModal();
    alert('✅ User berhasil diupdate!');
}

function deleteUser(key) {
    if (confirm(`❓ Apakah Anda yakin ingin menghapus user "${usersData[key].user}"?`)) {
        delete usersData[key];
        renderTable();
        alert('✅ User berhasil dihapus!');
    }
}

function logout() {
    if (confirm('❓ Apakah Anda yakin ingin logout?')) {
        window.location.href = 'login.html';
    }
}

function updateLastSync() {
    const now = new Date();
    const timeStr = now.toLocaleTimeString('id-ID');
    document.getElementById('lastSync').textContent = timeStr;
}

window.onload = function() {
    refreshData();
};
