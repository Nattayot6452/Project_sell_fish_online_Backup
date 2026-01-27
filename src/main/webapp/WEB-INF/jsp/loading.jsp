<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

    #loading-screen {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(to bottom, #e0f7fa, #ffffff); 
        z-index: 9999;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        transition: opacity 0.6s ease-out;
    }

    .fish-loader {
        width: 100px; 
        height: auto;
        animation: swim 2s infinite ease-in-out;
        filter: drop-shadow(0 10px 10px rgba(0,0,0,0.1));
        position: relative;
        z-index: 1; 
    }

    @keyframes swim {
        0%, 100% { transform: translateY(0) rotate(0deg); }
        50% { transform: translateY(-15px) rotate(-5deg); }
    }

    .bubbles-container {
        display: flex;
        gap: 15px;
        margin-top: -40px;
        position: relative;
        z-index: 10; 
    }
    
    .bubble {
        width: 15px;
        height: 15px;
        background-color: rgba(49, 130, 206, 0.8);
        border-radius: 50%;
        opacity: 0;

        animation: rise 1s infinite ease-in; 
    }
    
    .b1 { animation-delay: 0s; width: 10px; height: 10px; }
    .b2 { animation-delay: 0.3s; width: 20px; height: 20px; }
    .b3 { animation-delay: 0.6s; width: 12px; height: 12px; }

    @keyframes rise {
        0% { transform: translateY(0) scale(0.5); opacity: 0; }
        20% { opacity: 1; } 
        100% { transform: translateY(-150px) scale(1.2); opacity: 0; } 
    }

    .loading-text {
        margin-top: 30px; 
        font-family: 'Kanit', sans-serif;
        color: #2c5282;
        font-weight: bold;
        font-size: 1.2rem;
        letter-spacing: 1px;
        animation: pulse 1.5s infinite;
    }
    @keyframes pulse {
        0%, 100% { opacity: 0.6; }
        50% { opacity: 1; }
    }
</style>

<div id="loading-screen">
    <img src="${pageContext.request.contextPath}/assets/images/icon/fishloadingicon.png" 
         alt="Loading..." class="fish-loader">
    
    <div class="bubbles-container">
        <div class="bubble b1"></div>
        <div class="bubble b2"></div>
        <div class="bubble b3"></div>
    </div>
    
    <div class="loading-text">กำลังพาคุณดำดิ่งสู่โลกใต้น้ำ...</div>
</div>

<script>
    window.addEventListener("load", function() {
        const loader = document.getElementById("loading-screen");
        
        setTimeout(function() {
            loader.style.opacity = "0"; 
            
            setTimeout(function() {
                loader.style.display = "none";
            }, 600);
        }, 800);
    });
</script>