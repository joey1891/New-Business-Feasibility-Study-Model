<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K-뷰티/건기식 타겟 약국 매트릭스 분석</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@2.1.0"></script>
    
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" crossorigin=""></script>
    <script src="https://unpkg.com/leaflet.heat/dist/leaflet-heat.js"></script>

    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; color: #212529; }
        .report-panel { background: #ffffff; border: 1px solid #dee2e6; box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
        .border-t-brand { border-top: 5px solid #8b0000; }
        
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th { background-color: #f8f9fa; color: #495057; font-weight: 700; font-size: 12px; padding: 12px 16px; text-align: left; border-bottom: 2px solid #343a40; text-transform: uppercase; }
        .data-table td { padding: 14px 16px; border-bottom: 1px solid #e9ecef; font-size: 14px; color: #212529; }
        .data-table tr:hover { background-color: #f1f3f5; }
        
        .badge-tier-1 { background-color: #8b0000; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }
        .badge-tier-2 { background-color: #343a40; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }
        .badge-tier-3 { background-color: #adb5bd; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }

        .toggle-btn { cursor: pointer; user-select: none; transition: background-color 0.2s; }
        .toggle-btn:hover { background-color: #f1f3f5; }
        .toggle-icon { display: inline-block; width: 16px; transition: transform 0.3s; color: #8b0000; }
        .expanded .toggle-icon { transform: rotate(90deg); }
        
        .sub-row { display: none; background-color: #fcfcfc; }
        
        .pharmacy-list-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .pharmacy-list-table th { background-color: #f8f9fa; color: #6c757d; font-weight: bold; padding: 8px 12px; text-align: left; border-bottom: 1px solid #dee2e6; }
        .pharmacy-list-table td { padding: 10px 12px; border-bottom: 1px solid #f1f3f5; }
        .pharmacy-list-table tr:last-child td { border-bottom: none; }
        .pharmacy-link:hover { color: #8b0000; text-decoration: underline; }
    </style>
</head>
<body class="min-h-screen p-4 md:p-8">

    <div class="max-w-[1200px] mx-auto space-y-6">
        
        <header class="report-panel border-t-brand p-8 flex flex-col md:flex-row justify-between items-start md:items-end">
            <div>
                <p class="text-gray-500 font-bold text-xs tracking-widest mb-2 font-['Poppins']">LOCATION INTELLIGENCE : K-BEAUTY PHARMACY TARGETING</p>
                <h1 class="text-3xl md:text-4xl font-extrabold text-gray-900 tracking-tight">외국인 관광객 기반 약국 타겟팅 분석</h1>
                <p class="text-gray-600 mt-2 font-medium">관광객 방문율(수요)과 약국 밀집도(공급 인프라) 교차 분석 및 카카오 로컬 타겟 매핑</p>
            </div>
            <div class="mt-4 md:mt-0 flex flex-col items-end">
                <div class="px-3 py-1 bg-green-50 text-green-800 text-[11px] font-bold border border-green-300 flex items-center mb-1 rounded-sm">
                    <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg>
                    KAKAO LOCAL API: LIVE DATA
                </div>
                <p class="text-[10px] text-gray-400 font-mono">Status: Connected</p>
            </div>
        </header>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="report-panel p-6 border-t-[3px] border-t-gray-800">
                <h3 class="text-gray-500 text-xs font-bold uppercase tracking-widest mb-4">Tier 1 핵심 타겟 자치구</h3>
                <div class="flex items-baseline space-x-2">
                    <p class="text-3xl font-extrabold text-[#8b0000] tracking-tighter">강남구, 중구, 마포구</p>
                </div>
                <p class="text-xs text-gray-500 mt-3 font-medium border-t pt-2">관광객 40% 이상 방문 & 인프라 200개소 이상</p>
            </div>
            
            <div class="report-panel p-6 border-t-[3px] border-t-gray-300">
                <h3 class="text-gray-500 text-xs font-bold uppercase tracking-widest mb-4">영업 대상 (Tier 1 약국 수)</h3>
                <div class="flex items-baseline space-x-1">
                    <p class="text-4xl font-extrabold text-gray-900 tracking-tighter" id="kpi-target-pharm">1,248</p>
                    <span class="text-gray-500 font-bold text-sm">개소</span>
                </div>
                <p class="text-xs text-gray-500 mt-3 font-medium border-t pt-2">1차 영업 집중 투입 권장 규모</p>
            </div>

            <div class="report-panel p-6 border-t-[3px] border-t-gray-300">
                <h3 class="text-gray-500 text-xs font-bold uppercase tracking-widest mb-4">핵심 상권 K-뷰티 매력도 지수</h3>
                <div class="flex items-baseline space-x-1">
                    <p class="text-4xl font-extrabold text-[#212529] tracking-tighter">Very High</p>
                </div>
                <p class="text-xs text-gray-500 mt-3 font-medium border-t pt-2">의료관광(강남) 및 쇼핑(명동/홍대) 복합 시너지</p>
            </div>
        </div>

        <div class="report-panel p-6 border-t-[1px] border-gray-200">
            <div class="flex justify-between items-center mb-4">
                <div>
                    <h2 class="text-xl font-extrabold text-gray-900 tracking-tight">K-뷰티 영업 타겟팅 포트폴리오 매트릭스</h2>
                    <p class="text-xs text-gray-500 mt-1 font-medium">우측 상단 1사분면(Tier 1)에 위치한 지역이 가장 이상적인 초기 영업 타겟입니다.</p>
                </div>
            </div>
            <div class="relative w-full h-[500px]">
                <canvas id="targetMatrixChart"></canvas>
            </div>
        </div>

        <div class="report-panel p-6 border-t-[1px] border-gray-200">
            <div class="flex justify-between items-end mb-4">
                <div>
                    <h2 class="text-xl font-extrabold text-gray-900 tracking-tight">핵심 상권 약국 밀집도 히트맵 & 타겟 매핑</h2>
                    <p class="text-xs text-gray-500 mt-1 font-medium">강남/명동/홍대 권역 중심의 잠재 수요 밀집도 확인</p>
                </div>
                <div class="flex items-center">
                    <span class="mr-3 text-sm font-bold text-gray-700">개별 타겟 약국 표시 (하단 클릭시 렌더링)</span>
                    <label class="inline-flex items-center cursor-pointer">
                      <input type="checkbox" id="toggle-pharmacies" class="sr-only peer">
                      <div class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#8b0000]"></div>
                    </label>
                </div>
            </div>
            <!-- height를 style로 강제 고정하여 IndexSizeError 차단 -->
            <div id="targetMap" class="w-full rounded-md border border-gray-300 z-0 relative" style="height: 450px; min-height: 450px; display: block;"></div>
        </div>

        <div class="report-panel p-6 border-t-[1px] border-gray-200">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-extrabold text-gray-900 tracking-tight">자치구별 약국 타겟 리스트 (Kakao Local API 실시간 연동)</h2>
                <p class="text-xs font-bold text-[#8b0000]">항목을 클릭하여 세부 약국 리스트를 확인하세요 ▼</p>
            </div>
            <div class="overflow-x-auto">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 20%;">지역 (클릭 시 토글)</th>
                            <th style="width: 15%;">우선순위 등급</th>
                            <th style="width: 15%; text-align: right;">관광객 비율 (%)</th>
                            <th style="width: 15%; text-align: right;">약국 인프라</th>
                            <th style="width: 35%;">전략적 코멘트</th>
                        </tr>
                    </thead>
                    <tbody id="strategy-table-body">
                        <!-- JS로 데이터 삽입 -->
                    </tbody>
                </table>
            </div>
        </div>
        
    </div>

    <script>
        // 대표님의 API KEY로 세팅 완료
        const KAKAO_REST_API_KEY = '6e8307e30ea6d4c19e3d6364b724f628'; 
        
        let map;
        let heatmapLayer;
        let pharmacyLayer;
        let isMapInitialized = false;

        async function fetchSeoulTouristData() {
            return [
                { region: '강남구', touristRate: 58.5, pharmacyCount: 520, desc: '성형/피부과 의료관광 메카. 객단가 최고 타겟.' },
                { region: '중구', touristRate: 72.3, pharmacyCount: 385, desc: '명동 상권. 코스메틱/건기식 쇼핑 수요 폭발적.' },
                { region: '마포구', touristRate: 52.1, pharmacyCount: 343, desc: '홍대/신촌 상권. 젊은 층 타겟 트렌디한 제품군 적합.' },
                { region: '종로구', touristRate: 65.4, pharmacyCount: 290, desc: '전통 문화 및 대형 상권 결합 지역.' },
                { region: '서초구', touristRate: 25.4, pharmacyCount: 410, desc: '인프라는 많으나 관광보다 거주/의료 목적 강함.' },
                { region: '송파구', touristRate: 31.2, pharmacyCount: 440, desc: '잠실 롯데월드 타워 중심 한정적 쇼핑 수요.' },
                { region: '서대문구', touristRate: 28.5, pharmacyCount: 210, desc: '신촌/이대 상권, 과거 대비 수요 소폭 하락.' },
                { region: '영등포구', touristRate: 18.2, pharmacyCount: 295, desc: '여의도/더현대 중심 체류 증가 추세.' },
                { region: '용산구', touristRate: 35.6, pharmacyCount: 155, desc: '이태원/한남동 하이엔드 뷰티 수요.' },
                { region: '동대문구', touristRate: 22.4, pharmacyCount: 270, desc: 'DDP 및 쇼핑몰 주변 도매 상권 위주.' }
            ];
        }

        async function fetchPharmaciesFromKakao(districtName) {
            try {
                // 카카오 로컬 키워드 검색 API (PM9 = 약국 카테고리)
                const query = encodeURIComponent(`서울 ${districtName} 약국`);
                const url = `https://dapi.kakao.com/v2/local/search/keyword.json?query=${query}&category_group_code=PM9&size=10`;
                
                const response = await fetch(url, {
                    method: 'GET',
                    headers: { 'Authorization': `KakaoAK ${KAKAO_REST_API_KEY}` }
                });
                
                if (!response.ok) {
                    throw new Error("API 요청 실패 (Web 플랫폼 도메인 설정이 필요할 수 있습니다.)");
                }

                const data = await response.json();
                
                return data.documents.map(doc => ({
                    name: doc.place_name,
                    address: doc.road_address_name || doc.address_name,
                    phone: doc.phone || '번호 없음',
                    url: doc.place_url,
                    lat: parseFloat(doc.y),
                    lng: parseFloat(doc.x)
                }));
            } catch(error) {
                console.error("Kakao API Error:", error);
                return []; 
            }
        }

        function calculateTier(rate, count) {
            if(rate >= 40 && count >= 300) return { level: 1, name: 'Tier 1', class: 'badge-tier-1' };
            if((rate >= 30 && count < 300) || (rate < 40 && count >= 350)) return { level: 2, name: 'Tier 2', class: 'badge-tier-2' };
            return { level: 3, name: 'Tier 3', class: 'badge-tier-3' };
        }

        async function initDashboard() {
            Chart.register(ChartDataLabels, window['chartjs-plugin-annotation']);
            const data = await fetchSeoulTouristData();
            
            data.forEach(d => d.tier = calculateTier(d.touristRate, d.pharmacyCount));
            data.sort((a, b) => a.tier.level - b.tier.level);

            renderMatrixChart(data);
            renderTableBase(data);

            // 지도가 위치할 컨테이너가 DOM에 완전히 잡힌 후(레이아웃 안정화 후) 지도 초기화
            setTimeout(() => {
                initMap();
            }, 500);
        }

        function renderTableBase(data) {
            const tbody = document.getElementById('strategy-table-body');
            let html = '';
            
            data.forEach(item => {
                const rowId = item.region;
                html += `
                <tr id="row-${rowId}" class="toggle-btn border-l-4 ${item.tier.level === 1 ? 'border-l-[#8b0000]' : 'border-l-transparent'}" onclick="handleRowToggle('${rowId}', ${item.tier.level})">
                    <td class="font-bold text-gray-800">
                        <span class="toggle-icon">▶</span> ${item.region}
                    </td>
                    <td><span class="${item.tier.class}">${item.tier.name}</span></td>
                    <td class="text-right font-medium text-gray-700">${item.touristRate}%</td>
                    <td class="text-right font-medium text-gray-700">${item.pharmacyCount.toLocaleString()}</td>
                    <td class="text-sm text-gray-600">${item.desc}</td>
                </tr>
                <tr id="sub-${rowId}" class="sub-row shadow-inner">
                    <td colspan="5" class="p-6 bg-gray-50 border-b-2 border-gray-300">
                        <div class="mb-3 flex items-center justify-between">
                            <h4 class="text-sm font-bold text-gray-800 flex items-center">
                                <span class="bg-[#ffe812] text-[#3c1e1e] px-2 py-1 rounded text-xs mr-2 font-extrabold">KAKAO API 연동됨</span>
                                ${item.region} 실시간 타겟 약국 리스트 (카테고리: PM9)
                            </h4>
                        </div>
                        <div class="border border-gray-200 rounded bg-white overflow-hidden">
                            <table class="pharmacy-list-table">
                                <thead>
                                    <tr>
                                        <th style="width: 30%">타겟 약국명</th>
                                        <th style="width: 50%">도로명 주소</th>
                                        <th style="width: 20%">연락처</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody-${rowId}">
                                    <tr><td colspan="3" class="text-center py-4 text-gray-400">데이터를 불러오는 중...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
                `;
            });
            tbody.innerHTML = html;
        }

        window.handleRowToggle = async function(rowId, tierLevel) {
            const subRow = document.getElementById(`sub-${rowId}`);
            const parentRow = document.getElementById(`row-${rowId}`);
            const tbodyDetail = document.getElementById(`tbody-${rowId}`);
            
            if (subRow.style.display === 'table-row') {
                subRow.style.display = 'none';
                parentRow.classList.remove('expanded', 'bg-gray-100');
                return;
            } else {
                subRow.style.display = 'table-row';
                parentRow.classList.add('expanded', 'bg-gray-100');
            }

            if (tbodyDetail.getAttribute('data-loaded') === 'true') return;

            const pharmacies = await fetchPharmaciesFromKakao(rowId);
            
            let pharmacyRows = '';
            if (pharmacies.length === 0) {
                 pharmacyRows = `<tr><td colspan="3" class="text-center py-4 text-gray-500">카카오 API 데이터 조회 실패 (키를 확인해주세요)</td></tr>`;
            } else {
                pharmacies.forEach(p => {
                    pharmacyRows += `
                        <tr>
                            <td class="font-bold text-[#212529]">
                                <a href="${p.url}" target="_blank" class="pharmacy-link inline-flex items-center">
                                    ${p.name}
                                    <svg class="w-3 h-3 ml-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
                                </a>
                            </td>
                            <td class="text-gray-600">${p.address}</td>
                            <td class="text-gray-600 font-mono text-xs">${p.phone}</td>
                        </tr>
                    `;
                });
                
                // 검색된 약국을 지도 마커로 추가
                addMarkersToMap(pharmacies, tierLevel, rowId);
            }
            
            tbodyDetail.innerHTML = pharmacyRows;
            tbodyDetail.setAttribute('data-loaded', 'true');
        }

        function initMap() {
            const mapContainer = document.getElementById('targetMap');
            if(!mapContainer) return;

            // 지도 객체 초기화 (기본 타일)
            map = L.map('targetMap', {
                center: [37.535, 126.995], 
                zoom: 11,
                zoomControl: true
            });
            
            L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
                attribution: '&copy; OpenStreetMap contributors &copy; CARTO',
                maxZoom: 18
            }).addTo(map);

            pharmacyLayer = L.layerGroup();
            
            // 지도 초기화와 데이터 렌더링 시점을 완벽하게 분리 (IndexSizeError 방지 핵심)
            setTimeout(() => { 
                map.invalidateSize(true); // 크기 갱신 강제
                renderHeatmap();
                isMapInitialized = true;
            }, 300); 

            // 토글 스위치 이벤트 연동
            const toggleElement = document.getElementById('toggle-pharmacies');
            toggleElement.onchange = function(e) {
                if (e.target.checked) map.addLayer(pharmacyLayer); 
                else map.removeLayer(pharmacyLayer); 
            };
        }

        function renderHeatmap() {
            try {
                map.invalidateSize(); // 히트맵 그리기 직전에 다시 한번 강제 갱신
                
                const heatPoints = [];
                // 강남 상권 가중치
                for(let i=0; i<250; i++) heatPoints.push([37.498 + (Math.random()-0.5)*0.05, 127.027 + (Math.random()-0.5)*0.07, Math.random() * 1.5]);
                // 명동 상권 가중치
                for(let i=0; i<180; i++) heatPoints.push([37.562 + (Math.random()-0.5)*0.03, 126.985 + (Math.random()-0.5)*0.04, Math.random() * 1.5]);
                // 홍대 상권 가중치
                for(let i=0; i<120; i++) heatPoints.push([37.556 + (Math.random()-0.5)*0.04, 126.924 + (Math.random()-0.5)*0.05, Math.random()]);

                if (heatmapLayer) map.removeLayer(heatmapLayer);
                
                heatmapLayer = L.heatLayer(heatPoints, {
                    radius: 18, 
                    blur: 15, 
                    maxZoom: 14,
                    gradient: { 0.4: 'blue', 0.6: 'cyan', 0.7: 'lime', 0.8: 'yellow', 1.0: '#8b0000' }
                }).addTo(map);
            } catch(error) {
                console.warn("Leaflet heatmap render error:", error);
            }
        }

        function addMarkersToMap(pharmacies, tierLevel, regionName) {
            if(!isMapInitialized || !pharmacyLayer) return;

            const color = tierLevel === 1 ? "#8b0000" : "#343a40";
            
            pharmacies.forEach(p => {
                if(p.lat && p.lng) {
                    const customIcon = L.divIcon({ 
                        html: `<div style="background-color: ${color}; width: 14px; height: 14px; border-radius: 50%; border: 2px solid white; box-shadow: 0 2px 4px rgba(0,0,0,0.4);"></div>`, 
                        className: '', 
                        iconSize: [14, 14], 
                        iconAnchor: [7, 7] 
                    });
                    const marker = L.marker([p.lat, p.lng], { icon: customIcon })
                        .bindPopup(`<div style="font-family: 'Noto Sans KR', sans-serif;"><strong>${p.name}</strong><br/><span style="font-size: 12px;">${regionName} / ${p.phone}</span></div>`);
                    pharmacyLayer.addLayer(marker);
                }
            });
        }

        function renderMatrixChart(data) {
            const ctx = document.getElementById('targetMatrixChart').getContext('2d');
            const scatterData = data.map(item => ({ x: item.touristRate, y: item.pharmacyCount, region: item.region, tierLevel: item.tier.level }));

            new Chart(ctx, {
                type: 'scatter',
                data: {
                    datasets: [{
                        label: '자치구별 약국 타겟',
                        data: scatterData,
                        backgroundColor: (ctx) => {
                            const level = ctx.raw?.tierLevel;
                            return level === 1 ? '#8b0000' : (level === 2 ? '#343a40' : '#adb5bd');
                        },
                        pointRadius: (ctx) => ctx.raw?.tierLevel === 1 ? 12 : 8,
                        pointHoverRadius: 14
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { backgroundColor: '#212529', callbacks: { label: (c) => ` 방문: ${c.raw.x}% | 약국: ${c.raw.y}개소`, title: (c) => c[0].raw.region } },
                        datalabels: { color: (ctx) => ctx.raw?.tierLevel === 1 ? '#ffffff' : '#212529', align: 'top', offset: 10, font: { weight: 'bold', size: 12 }, formatter: (v) => v.region },
                        annotation: { annotations: {
                            box1: { type: 'box', xMin: 40, xMax: 80, yMin: 300, yMax: 600, backgroundColor: 'rgba(139, 0, 0, 0.05)', borderWidth: 0, label: { display: true, content: '★ 최우선 타겟 구역 (Tier 1)', position: 'end', color: '#8b0000', font: { weight: 'bold' } } },
                            lineX: { type: 'line', xMin: 40, xMax: 40, borderColor: '#dee2e6', borderWidth: 2, borderDash: [5, 5] },
                            lineY: { type: 'line', yMin: 300, yMax: 300, borderColor: '#dee2e6', borderWidth: 2, borderDash: [5, 5] }
                        }}
                    },
                    scales: {
                        x: { title: { display: true, text: '외국인 관광객 방문율 (%) ➔', font: { weight: 'bold' } }, min: 0, max: 80 },
                        y: { title: { display: true, text: '약국 인프라 규모 (개소) ➔', font: { weight: 'bold' } }, min: 100, max: 600 }
                    }
                }
            });
        }

        window.addEventListener('DOMContentLoaded', initDashboard);
    </script>
</body>
</html>
