<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Lỗi rồi 😭</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                height: 100vh;
                background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
                background-size: 400% 400%;
                animation: gradientBG 15s ease infinite;
                display: flex;
                justify-content: center;
                align-items: center;
                color: white;
                overflow: hidden;

                position: relative;
                z-index: 0;
            }

            /* Canvas mạng lưới công nghệ */
            #tech-canvas {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                z-index: 0;
                pointer-events: none;
            }

            @keyframes gradientBG {
                0% { background-position: 0% 50%; }
                50% { background-position: 100% 50%; }
                100% { background-position: 0% 50%; }
            }

            .container {
                text-align: center;
                animation: fadeIn 1s ease-out;

                position: relative;
                z-index: 1;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(-30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .emoji {
                font-size: 8rem;
                animation: bounce 2s infinite;
            }

            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-20px); }
            }

            h1 {
                font-size: 3rem;
                margin: 20px 0;
                animation: shake 2s infinite;
            }

            @keyframes shake {
                0% { transform: translateX(0); }
                25% { transform: translateX(-5px); }
                50% { transform: translateX(5px); }
                75% { transform: translateX(-5px); }
                100% { transform: translateX(0); }
            }

            p {
                font-size: 1.2rem;
                margin-bottom: 30px;
            }

            .btn {
                padding: 12px 25px;
                font-size: 1rem;
                background: rgba(255,255,255,0.2);
                border: 2px solid white;
                color: white;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
            }

            .btn:hover {
                background: white;
                color: #333;
                box-shadow: 0 0 10px white;
            }
        </style>
    </head>

    <body>
        <canvas id="tech-canvas"></canvas>

        <div class="container">
            <%-- ⚠️ 😭 😢 😁 😉 --%>
            <div class="emoji"> <%--<img src="<%= ResolveUrl("~/Picture_Resources/Fun_Voz/too_sad.png") %>" alt="😭" />--%>
                😭
            </div>
            <h1> Oops! Đã xảy ra lỗi </h1>
            <p> Có vẻ chúng ta đã gặp một chút trục trặc. Vui lòng thử lại sau. </p>
            <a class="btn" href="javascript:history.back()">🔙 Quay lại</a>
        </div>

        <%-- Script --%>
        <script>
            const canvas = document.getElementById('tech-canvas');
            const ctx = canvas.getContext('2d');

            let width, height;
            let points = [];

            function init() {
                resize();
                createPoints();
                animate();
            }

            // Điều chỉnh canvas full màn hình
            function resize() {
                width = window.innerWidth;
                height = window.innerHeight;
                canvas.width = width;
                canvas.height = height;
            }

            // Tạo các điểm ngẫu nhiên trên màn hình
            function createPoints() {
                points = [];
                const spacing = 80;
                for (let x = spacing / 2; x < width; x += spacing) {
                    for (let y = spacing / 2; y < height; y += spacing) {
                        points.push({
                            x: x + (Math.random() * spacing - spacing / 2) * 0.3,
                            y: y + (Math.random() * spacing - spacing / 2) * 0.3,
                            originX: x,
                            originY: y,
                            vx: (Math.random() - 0.5) * 0.3,
                            vy: (Math.random() - 0.5) * 0.3,
                        });
                    }
                }
            }

            // Tính khoảng cách giữa 2 điểm
            function dist(a, b) {
                return Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2);
            }

            // Vẽ từng điểm và đường nối gần nhau
            function draw() {
                ctx.clearRect(0, 0, width, height);
                ctx.fillStyle = 'rgba(255,255,255,0.4)';
                ctx.strokeStyle = 'rgba(255,255,255,0.15)';
                ctx.lineWidth = 1;

                // Vẽ đường nối các điểm gần nhau
                for (let i = 0; i < points.length; i++) {
                    let p1 = points[i];
                    for (let j = i + 1; j < points.length; j++) {
                        let p2 = points[j];
                        let distance = dist(p1, p2);
                        if (distance < 120) {
                            ctx.beginPath();
                            ctx.moveTo(p1.x, p1.y);
                            ctx.lineTo(p2.x, p2.y);
                            ctx.stroke();
                            ctx.closePath();
                        }
                    }
                }

                // Vẽ các điểm
                points.forEach(p => {
                    ctx.beginPath();
                    ctx.arc(p.x, p.y, 3, 0, Math.PI * 2);
                    ctx.fill();
                });
            }

            // Cập nhật vị trí điểm theo vận tốc, tạo hiệu ứng chuyển động nhẹ
            function update() {
                points.forEach(p => {
                    p.x += p.vx;
                    p.y += p.vy;

                    // Điểm dịch chuyển quanh vị trí gốc, tạo hiệu ứng dao động nhỏ
                    if (p.x < p.originX - 10 || p.x > p.originX + 10) p.vx = -p.vx;
                    if (p.y < p.originY - 10 || p.y > p.originY + 10) p.vy = -p.vy;
                });
            }

            function animate() {
                update();
                draw();
                requestAnimationFrame(animate);
            }

            window.addEventListener('resize', () => {
                resize();
                createPoints();
            });

            init();
        </script>
    </body>
</html>
