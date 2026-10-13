<%@ page pageEncoding="UTF-8" %>
<%-- Общие стили страниц постовой медсестры. Планшет: кнопки и строки не меньше 44px, крупный шрифт. --%>
<style>
  .np { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    min-height:100%; box-sizing:border-box; padding:12px 14px 24px; background:var(--bg);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); font-size:15px; }
  .np * { box-sizing:border-box; }
  .np-head { display:flex; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:12px; }
  .np-title { display:flex; align-items:center; gap:12px; min-width:0; }
  .np-title .ic { width:42px; height:42px; border-radius:12px; display:flex; align-items:center; justify-content:center; background:#EEF1F6; color:#3C4A63; font-size:18px; flex:none; }
  .np-title h2 { margin:0; font-size:19px; font-weight:700; line-height:1.2; }
  .np-title .sub { display:block; margin-top:2px; font-size:13.5px; color:var(--muted); }
  .np-title .sub b { color:var(--text); }
  .np .warn { color:#B45309; font-weight:600; }
  .np-spacer { flex:1; }
  .np-seg { display:flex; padding:3px; background:#E9EBEF; border-radius:12px; }
  .np-seg button { height:44px; padding:0 18px; border:0; border-radius:10px; background:none; color:var(--muted); font-size:15px; font-weight:600; font-family:inherit; cursor:pointer; }
  .np-seg button.on { background:#fff; color:var(--text); box-shadow:0 1px 3px rgba(20,25,40,.12); }
  .np-btn { height:44px; padding:0 16px; border:1px solid var(--border); border-radius:12px; background:#fff; color:var(--text); font-size:15px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; }
  .np-btn .fa { margin-right:7px; }
  .np-btn.tg { color:#1C6E99; border-color:#BFE3F5; background:#F0F8FD; }
  .np-btn.tg .fa { color:#229ED9; }
  .np-in { height:44px; padding:0 12px; border:1px solid var(--border); border-radius:12px; background:#fff; font-size:15px; font-family:inherit; color:var(--text); width:150px; }

  /* плитки палат */
  .np-rooms { display:grid; grid-template-columns:repeat(auto-fill, minmax(200px, 1fr)); gap:12px; }
  .np-room { display:flex; flex-direction:column; align-items:stretch; gap:10px; min-height:132px; padding:14px; text-align:left;
    background:#fff; border:1px solid var(--border); border-left:5px solid #C3C7CE; border-radius:16px; cursor:pointer; font-family:inherit; color:var(--text);
    box-shadow:0 1px 2px rgba(20,25,40,.04), 0 6px 18px rgba(20,25,40,.05); }
  .np-room:active { transform:scale(.98); }
  .np-room.pending { border-left-color:#F59E0B; }
  .np-room.done { border-left-color:#22A55B; }
  .np-room .rn { font-size:22px; font-weight:700; line-height:1.1; }
  .np-room .rn small { display:block; margin-top:3px; font-size:12.5px; font-weight:500; color:var(--muted); }
  .np-room .people { display:flex; flex-wrap:wrap; gap:6px; font-size:24px; }
  .np-room .st { margin-top:auto; font-size:13.5px; color:var(--muted); font-weight:600; }
  .np-room.pending .st { color:#B45309; }
  .np-room.done .st { color:#1E7B43; }
  .p-pend { color:#F59E0B; } .p-done { color:#22A55B; } .p-none { color:#C3C7CE; }

  /* выбор пациента */
  .np-pats { display:grid; grid-template-columns:repeat(auto-fill, minmax(240px, 1fr)); gap:10px; margin-bottom:14px; }
  .np-pat { display:flex; align-items:center; gap:12px; min-height:72px; padding:12px 14px; text-align:left; background:#fff;
    border:2px solid var(--border); border-radius:16px; cursor:pointer; font-family:inherit; color:var(--text); }
  .np-pat.on { border-color:#1F2430; box-shadow:0 0 0 3px rgba(31,36,48,.08); }
  .np-pat .av { width:44px; height:44px; flex:none; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:22px; background:#F1F2F4; }
  .np-pat .nm { display:block; font-size:15.5px; font-weight:700; line-height:1.25; }
  .np-pat .mt { display:block; margin-top:3px; font-size:13px; color:var(--muted); }
  .np-pat .badge { margin-left:auto; flex:none; min-width:30px; height:30px; padding:0 9px; border-radius:15px; display:flex; align-items:center; justify-content:center; font-size:14px; font-weight:700; }
  .np-pat .badge.pend { background:#FEF3C7; color:#B45309; }
  .np-pat .badge.ok { background:#E9F7EF; color:#1E7B43; }

  .np-card { background:#fff; border:1px solid var(--border); border-radius:16px; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }
  .np-card-head { display:flex; align-items:center; flex-wrap:wrap; gap:10px; padding:12px 16px; border-bottom:1px solid var(--border); }
  .np-card-head h3 { margin:0; font-size:17px; font-weight:700; }
  .np-card-head .sub { display:block; font-size:13px; color:var(--muted); }
  .np-card-body { padding:12px 16px 18px; }

  /* назначения (proc/drugs.jsp) крупнее для пальцев */
  #home table { font-size:15px !important; }
  #home td { padding:8px 8px !important; }
  #home .btn-sm, #home button { min-width:44px; min-height:40px; font-size:16px; border-radius:10px; }
  #home input[readonly] { width:44px !important; height:40px; font-size:16px; border:1px solid var(--border); border-radius:8px; }

  .np-empty { padding:60px 20px; text-align:center; color:#9AA1AC; font-size:15px; }
  .np-empty .fa { display:block; font-size:40px; margin-bottom:12px; color:#D5D8DE; }
  @media (max-width: 700px) { .np-seg button { padding:0 12px; } .np-title h2 { font-size:17px; } }
</style>
