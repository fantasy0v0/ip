@import com.ip2location.IPResult
@param String ip
@param IPResult result
@param long cost
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IP 信息查询 - IP2Location</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" rel="stylesheet">
    
    <style>
        /* ================= 基础样式 ================= */
        :root {
            --primary: #2563eb;       /* 主色调 */
            --primary-hover: #1d4ed8; /* 按钮悬停色 */
            --bg: #f8fafc;            /* 背景色 */
            --card-bg: #ffffff;       /* 卡片背景 */
            --text-main: #0f172a;     /* 主文字 */
            --text-sub: #64748b;      /* 次要文字 */
            --border: #e2e8f0;        /* 边框色 */
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Microsoft YaHei", "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg);
            color: var(--text-main);
            margin: 0;
            padding: 20px 10px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        @media (max-width: 400px) {
            body {
                padding: 20px 8px;
            }
        }

        .container {
            width: 100%;
            max-width: 700px; /* 限制最大宽度 */
            margin-top: 40px;
        }

        /* ================= 搜索框区域 ================= */
        .search-card {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            text-align: center;
            margin-bottom: 24px;
            border: 1px solid var(--border);
        }

        @media (max-width: 400px) {
            .search-card {
                padding: 20px 12px;
            }
        }

        .search-title {
            margin: 0 0 20px 0;
            font-size: 1.5rem;
            color: var(--text-main);
        }

        /* 原生表单样式 */
        .search-form {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        @media (max-width: 400px) {
            .search-form {
                gap: 8px;
            }
        }

        .ip-input {
            flex: 1;
            max-width: 400px;
            padding: 12px 16px;
            font-size: 1rem;
            border: 2px solid var(--border);
            border-radius: 8px;
            outline: none;
            transition: border-color 0.2s;
        }

        .ip-input:focus {
            border-color: var(--primary);
        }

        .submit-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 0 24px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
            flex-shrink: 0;
        }

        @media (max-width: 400px) {
            .submit-btn {
                padding: 0 16px;
                font-size: 0.9rem;
            }
        }

        .submit-btn:hover {
            background-color: var(--primary-hover);
        }

        /* ================= 结果展示区域 ================= */
        .result-card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border);
            overflow: hidden;
        }

        /* 顶部 IP 大字展示 */
        .result-header {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }

        .header-label {
            font-size: 0.875rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .header-ip {
            font-size: 2.25rem;
            font-weight: 700;
            font-family: monospace; /* 等宽字体适合显示IP */
            margin: 0;
        }

        /* 数据网格 */
        .info-list {
            display: grid;
            grid-template-columns: repeat(2, 1fr); /* 两列布局 */
            gap: 1px;
            background-color: var(--border); /*利用背景色做边框线*/
            padding-top: 1px; /* 顶部边框 */
        }

        .info-item {
            background-color: var(--card-bg);
            padding: 20px;
            display: flex;
            flex-direction: column;
        }

        /* 手机端改为单列 */
        @media (max-width: 600px) {
            .info-list {
                grid-template-columns: 1fr;
            }
        }

        .label {
            font-size: 0.85rem;
            color: var(--text-sub);
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .value {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-main);
            word-break: break-all;
        }

        .footer {
            margin-top: 30px;
            text-align: center;
            font-size: 0.8rem;
            color: var(--text-sub);
        }

        /* 如果服务端没数据，可以给这个类加上 display: none */
        .hide-if-empty {
            /* display: none; */
        }
    </style>
</head>
<body>

    <div class="container">
        <section class="search-card">
            <h1 class="search-title">IP 地址查询</h1>
            <form action="" method="GET" class="search-form">
                <input 
                    type="text" 
                    name="ip" 
                    class="ip-input" 
                    placeholder="输入 IP 地址"
                    required
                    value="${ip}"
                >
                <button type="submit" class="submit-btn">
                    <i class="fa-solid fa-magnifying-glass"></i> 查询
                </button>
            </form>
        </section>

        <section class="result-card">
            <div class="result-header">
                <div class="header-label">Information For</div>
                <div class="header-ip">${ip}</div>
            </div>

            <div class="info-list">
                <div class="info-item">
                    <div class="label"><i class="fa-solid fa-flag"></i> 国家 (Country)</div>
                    <div class="value">${result.getCountryLong()}/${result.getCountryShort()}</div>
                </div>

                <div class="info-item">
                    <div class="label"><i class="fa-solid fa-map"></i> 区域 (Region)</div>
                    <div class="value">${result.getRegion()}</div>
                </div>

                <div class="info-item">
                    <div class="label"><i class="fa-solid fa-city"></i> 城市 (City)</div>
                    <div class="value">${result.getCity()}</div>
                </div>

                <div class="info-item">
                    <div class="label"><i class="fa-solid fa-location-crosshairs"></i> 经纬度 (Lat/Long)</div>
                    <div class="value">${result.getLatitude()}, ${result.getLongitude()}</div>
                </div>

                <div class="info-item">
                    <div class="label"><i class="fa-solid fa-envelope"></i> 邮政编码 (Zip Code)</div>
                    <div class="value">${result.getZipCode()}</div>
                </div>

                <div class="info-item">
                    <div class="label"><i class="fa-solid fa-clock"></i> 时区 (Time Zone)</div>
                    <div class="value">${result.getTimeZone()}</div>
                </div>
            </div>
        </section>

        <div class="footer">
            Data provided by <a href="https://www.ip2location.com" target="_blank" style="color: inherit;">IP2Location</a>
        </div>

        <div class="footer">
            耗时 ${cost} ms
        </div>
    </div>

</body>
</html>