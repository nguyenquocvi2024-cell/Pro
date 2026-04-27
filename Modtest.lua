<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Demo Menu Tính Năng</title>
  <style>
    * {
      box-sizing: border-box;
      user-select: none;
    }

    body {
      margin: 0;
      height: 100vh;
      background:
        radial-gradient(circle at top, #222 0%, #090909 60%),
        #111;
      font-family: Arial, sans-serif;
      color: white;
      overflow: hidden;
    }

    .background-text {
      position: fixed;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 38px;
      color: rgba(255,255,255,0.08);
      text-align: center;
      pointer-events: none;
    }

    .menu {
      width: 360px;
      background: rgba(18, 18, 18, 0.96);
      border: 1px solid rgba(0, 255, 170, 0.35);
      border-radius: 16px;
      position: fixed;
      top: 80px;
      left: 80px;
      box-shadow: 0 0 30px rgba(0, 255, 170, 0.18);
      overflow: hidden;
      z-index: 999;
    }

    .menu-header {
      padding: 14px 16px;
      background: linear-gradient(90deg, #00aa77, #0055ff);
      cursor: move;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .menu-title {
      font-size: 18px;
      font-weight: bold;
      letter-spacing: 0.5px;
    }

    .menu-small {
      font-size: 12px;
      opacity: 0.9;
    }

    .tabs {
      display: flex;
      background: #151515;
      border-bottom: 1px solid #2b2b2b;
    }

    .tab {
      flex: 1;
      text-align: center;
      padding: 10px;
      cursor: pointer;
      font-size: 14px;
      color: #aaa;
    }

    .tab.active {
      color: #00ffaa;
      background: #202020;
    }

    .content {
      padding: 14px;
      display: none;
    }

    .content.active {
      display: block;
    }

    .feature {
      background: #202020;
      border: 1px solid #303030;
      border-radius: 12px;
      padding: 12px;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .feature-info {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .feature-name {
      font-size: 15px;
      font-weight: bold;
    }

    .feature-desc {
      font-size: 12px;
      color: #999;
    }

    .switch {
      width: 52px;
      height: 26px;
      background: #555;
      border-radius: 99px;
      position: relative;
      cursor: pointer;
      transition: 0.2s;
      flex-shrink: 0;
    }

    .switch::before {
      content: "";
      width: 22px;
      height: 22px;
      background: white;
      border-radius: 50%;
      position: absolute;
      top: 2px;
      left: 2px;
      transition: 0.2s;
    }

    .switch.on {
      background: #00c985;
      box-shadow: 0 0 12px rgba(0, 255, 170, 0.5);
    }

    .switch.on::before {
      left: 28px;
    }

    .slider-box {
      background: #202020;
      border: 1px solid #303030;
      border-radius: 12px;
      padding: 12px;
      margin-bottom: 10px;
    }

    .slider-top {
      display: flex;
      justify-content: space-between;
      font-size: 14px;
      margin-bottom: 8px;
    }

    input[type="range"] {
      width: 100%;
      accent-color: #00ffaa;
    }

    .status {
      margin-top: 12px;
      background: #101010;
      border: 1px solid #252525;
      border-radius: 12px;
      padding: 12px;
      font-size: 13px;
      color: #ccc;
      line-height: 1.6;
    }

    .footer {
      padding: 10px 14px;
      font-size: 12px;
      color: #777;
      border-top: 1px solid #252525;
      background: #111;
      text-align: center;
    }

    .badge {
      padding: 3px 7px;
      background: rgba(0,255,170,0.14);
      color: #00ffaa;
      border-radius: 99px;
      font-size: 11px;
      border: 1px solid rgba(0,255,170,0.25);
    }
  </style>
</head>
<body>

  <div class="background-text">
    DEMO MENU UI<br>
    Không can thiệp vào game thật
  </div>

  <div class="menu" id="menu">
    <div class="menu-header" id="menuHeader">
      <div>
        <div class="menu-title">HND MENU DEMO</div>
        <div class="menu-small">UI bật/tắt tính năng mẫu</div>
      </div>
      <div class="badge">DEMO</div>
    </div>

    <div class="tabs">
      <div class="tab active" data-tab="combat">Combat</div>
      <div class="tab" data-tab="visual">Visual</div>
      <div class="tab" data-tab="movement">Move</div>
      <div class="tab" data-tab="misc">Misc</div>
    </div>

    <div class="content active" id="combat">
      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">Aim Assist</div>
          <div class="feature-desc">Demo trạng thái, không tự ngắm</div>
        </div>
        <div class="switch" data-key="aim"></div>
      </div>

      <div class="slider-box">
        <div class="slider-top">
          <span>Aim FOV Demo</span>
          <span id="fovValue">50</span>
        </div>
        <input type="range" min="1" max="100" value="50" id="fovSlider">
      </div>

      <div class="slider-box">
        <div class="slider-top">
          <span>Smooth Demo</span>
          <span id="smoothValue">30</span>
        </div>
        <input type="range" min="1" max="100" value="30" id="smoothSlider">
      </div>
    </div>

    <div class="content" id="visual">
      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">ESP Demo</div>
          <div class="feature-desc">Hiển thị mô phỏng trong project riêng</div>
        </div>
        <div class="switch" data-key="esp"></div>
      </div>

      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">ESP Vật Thể Demo</div>
          <div class="feature-desc">Trạng thái UI mẫu</div>
        </div>
        <div class="switch" data-key="objectEsp"></div>
      </div>

      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">Highlight Demo</div>
          <div class="feature-desc">Mô phỏng viền sáng</div>
        </div>
        <div class="switch" data-key="highlight"></div>
      </div>
    </div>

    <div class="content" id="movement">
      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">Fly Demo</div>
          <div class="feature-desc">Chỉ bật/tắt biến trạng thái</div>
        </div>
        <div class="switch" data-key="fly"></div>
      </div>

      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">Noclip Demo</div>
          <div class="feature-desc">Dành cho debug game riêng</div>
        </div>
        <div class="switch" data-key="noclip"></div>
      </div>

      <div class="slider-box">
        <div class="slider-top">
          <span>Speed Demo</span>
          <span id="speedValue">16</span>
        </div>
        <input type="range" min="1" max="100" value="16" id="speedSlider">
      </div>
    </div>

    <div class="content" id="misc">
      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">Tàng Hình Demo</div>
          <div class="feature-desc">Chỉ đổi trạng thái trong menu</div>
        </div>
        <div class="switch" data-key="invisible"></div>
      </div>

      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">God Mode Demo</div>
          <div class="feature-desc">Placeholder cho game riêng</div>
        </div>
        <div class="switch" data-key="godmode"></div>
      </div>

      <div class="feature">
        <div class="feature-info">
          <div class="feature-name">Auto Collect Demo</div>
          <div class="feature-desc">Placeholder hợp lệ trong project riêng</div>
        </div>
        <div class="switch" data-key="autocollect"></div>
      </div>
    </div>

    <div class="status" id="statusBox">
      Đang tải trạng thái...
    </div>

    <div class="footer">
      Nhấn <b>Insert</b> hoặc <b>M</b> để ẩn/hiện menu
    </div>
  </div>

  <script>
    const state = {
      aim: false,
      esp: false,
      objectEsp: false,
      highlight: false,
      fly: false,
      noclip: false,
      invisible: false,
      godmode: false,
      autocollect: false,
      fov: 50,
      smooth: 30,
      speed: 16
    };

    const menu = document.getElementById("menu");
    const menuHeader = document.getElementById("menuHeader");
    const statusBox = document.getElementById("statusBox");

    const fovSlider = document.getElementById("fovSlider");
    const smoothSlider = document.getElementById("smoothSlider");
    const speedSlider = document.getElementById("speedSlider");

    const fovValue = document.getElementById("fovValue");
    const smoothValue = document.getElementById("smoothValue");
    const speedValue = document.getElementById("speedValue");

    function updateStatus() {
      statusBox.innerHTML = `
        <b>Trạng thái hiện tại:</b><br>
        Aim Assist: ${state.aim ? "ON" : "OFF"}<br>
        ESP: ${state.esp ? "ON" : "OFF"}<br>
        ESP Vật Thể: ${state.objectEsp ? "ON" : "OFF"}<br>
        Highlight: ${state.highlight ? "ON" : "OFF"}<br>
        Fly: ${state.fly ? "ON" : "OFF"}<br>
        Noclip: ${state.noclip ? "ON" : "OFF"}<br>
        Tàng Hình: ${state.invisible ? "ON" : "OFF"}<br>
        God Mode: ${state.godmode ? "ON" : "OFF"}<br>
        Auto Collect: ${state.autocollect ? "ON" : "OFF"}<br>
        FOV: ${state.fov} | Smooth: ${state.smooth} | Speed: ${state.speed}
      `;
    }

    document.querySelectorAll(".switch").forEach(sw => {
      sw.addEventListener("click", () => {
        const key = sw.dataset.key;
        state[key] = !state[key];

        if (state[key]) {
          sw.classList.add("on");
        } else {
          sw.classList.remove("on");
        }

        updateStatus();
      });
    });

    document.querySelectorAll(".tab").forEach(tab => {
      tab.addEventListener("click", () => {
        document.querySelectorAll(".tab").forEach(t => t.classList.remove("active"));
        document.querySelectorAll(".content").forEach(c => c.classList.remove("active"));

        tab.classList.add("active");
        document.getElementById(tab.dataset.tab).classList.add("active");
      });
    });

    fovSlider.addEventListener("input", () => {
      state.fov = fovSlider.value;
      fovValue.textContent = state.fov;
      updateStatus();
    });

    smoothSlider.addEventListener("input", () => {
      state.smooth = smoothSlider.value;
      smoothValue.textContent = state.smooth;
      updateStatus();
    });

    speedSlider.addEventListener("input", () => {
      state.speed = speedSlider.value;
      speedValue.textContent = state.speed;
      updateStatus();
    });

    document.addEventListener("keydown", (e) => {
      if (e.key === "Insert" || e.key.toLowerCase() === "m") {
        menu.style.display = menu.style.display === "none" ? "block" : "none";
      }
    });

    let dragging = false;
    let offsetX = 0;
    let offsetY = 0;

    menuHeader.addEventListener("mousedown", (e) => {
      dragging = true;
      offsetX = e.clientX - menu.offsetLeft;
      offsetY = e.clientY - menu.offsetTop;
    });

    document.addEventListener("mousemove", (e) => {
      if (!dragging) return;

      menu.style.left = `${e.clientX - offsetX}px`;
      menu.style.top = `${e.clientY - offsetY}px`;
    });

    document.addEventListener("mouseup", () => {
      dragging = false;
    });

    updateStatus();
  </script>

</body>
</html>
