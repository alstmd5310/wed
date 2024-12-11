// 로그인 상태 체크 및 UI 업데이트
function updateLoginSection() {
    const loginSection = document.getElementById('loginSection');
    const userID = localStorage.getItem('userID');
    const userName = localStorage.getItem('name');

    if (userID && userName) {
        // 로그인 상태일 때
        loginSection.innerHTML = `
            <span onclick="location.href='mypage.html'" style="cursor: pointer;">${userName}</span>
            <span class="separator"></span>
            <span onclick="logout()" style="cursor: pointer;">로그아웃</span>
        `;
    } else {
        // 비로그인 상태일 때
        loginSection.innerHTML = `
            <span onclick="location.href='login.html'">로그인</span>
            <span class="separator"></span>
            <span onclick="location.href='signup.html'">회원가입</span>
        `;
    }
}

// 로그아웃 처리
function logout() {
    localStorage.removeItem('userID');
    localStorage.removeItem('name');
    updateLoginSection();
    location.href = 'index.html'; // 로그아웃 후 메인 페이지로 이동
}

// 공통 초기화 함수
function initializeCommonComponents() {
    updateLoginSection();

    // 카테고리 메뉴 생성
    const categories = ["상의", "하의", "신발", "악세서리"];
    const menuContainer = document.getElementById("menu");
    if (menuContainer) {
        menuContainer.innerHTML = ''; // 초기화
        categories.forEach(category => {
            const div = document.createElement("div");
            div.textContent = category;
            menuContainer.appendChild(div);
        });
    }

    // 사용자 정보 표시
    const userName = localStorage.getItem('name');
    if (userName) {
        const userNameElement = document.getElementById('userName');
        if (userNameElement) {
            userNameElement.textContent = userName;
        }
    }
}


// 페이지 로드 시 초기화 실행
window.onload = initializeCommonComponents;
