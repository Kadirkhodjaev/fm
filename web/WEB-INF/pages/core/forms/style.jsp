<%@ page pageEncoding="UTF-8" %>
<%-- Общие стили страниц «Администрирование → Формы» (подключается через include) --%>
<style>
  .fm-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    height:100%; box-sizing:border-box; display:flex; flex-direction:column; gap:8px;
    padding:10px 14px; background:var(--bg); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .fm-page * { box-sizing:border-box; }
  .fm-box { flex:1; min-height:0; display:flex; flex-direction:column; background:#fff; border:1px solid var(--border); border-radius:16px;
    overflow:hidden; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }
  .fm-toolbar { flex:none; display:flex; align-items:center; flex-wrap:wrap; gap:10px; padding:8px 14px; }
  .fm-title { display:flex; align-items:center; gap:12px; min-width:0; }
  .fm-title .ic { width:30px; height:30px; border-radius:9px; display:flex; align-items:center; justify-content:center; background:#EEF1F6; color:#3C4A63; font-size:14px; flex:none; }
  .fm-title h2 { margin:0; font-size:16px; font-weight:700; line-height:1.2; }
  .fm-count { display:block; font-size:12.5px; color:var(--muted); font-variant-numeric:tabular-nums; }
  .fm-count b { color:var(--text); font-weight:600; }
  .fm-spacer { flex:1; }
  .fm-seg { display:flex; padding:2px; background:#F1F2F4; border-radius:9px; }
  .fm-seg button { height:26px; padding:0 10px; border:0; border-radius:7px; background:none; color:var(--muted); font-size:12.5px; font-weight:600; font-family:inherit; cursor:pointer; }
  .fm-seg button.on { background:#fff; color:var(--text); box-shadow:0 1px 2px rgba(20,25,40,.08); }
  .fm-search-wrap { position:relative; }
  .fm-search-wrap .fa { position:absolute; left:10px; top:9px; color:#9AA1AC; font-size:12px; }
  .fm-search { width:220px; height:30px; padding:0 10px 0 28px; border:1px solid var(--border); border-radius:9px; font-size:13px; font-family:inherit; color:var(--text); }
  .fm-search:focus, .fm-in:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .fm-btn { height:30px; padding:0 12px; border:1px solid var(--border); border-radius:9px; background:#fff; color:#3C4250; font-size:12.5px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; }
  .fm-btn .fa { margin-right:6px; }
  .fm-btn:hover { background:#F5F6F8; }
  .fm-btn.primary { background:#1F2430; border-color:#1F2430; color:#fff; }
  .fm-btn.primary:hover { background:#353B4A; }
  .fm-btn.danger { color:#A50F22; }
  .fm-btn.danger:hover { background:#FDECEE; border-color:#F3C5CB; }
  .fm-btn[disabled] { opacity:.6; cursor:default; }

  .fm-table-wrap { flex:1; min-height:0; overflow:auto; border-top:1px solid var(--border); }
  table.fm-grid { width:100%; margin:0; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.fm-grid thead th { position:sticky; top:0; z-index:2; height:32px; padding:0 8px; background:#F8F9FA; border-bottom:1px solid var(--border);
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  table.fm-grid td { height:38px; padding:0 8px; border-bottom:1px solid #F0F1F4; vertical-align:middle; font-variant-numeric:tabular-nums; }
  table.fm-grid tbody tr { cursor:default; }
  table.fm-grid tbody tr:hover td { background:#F8F9FB; }
  table.fm-grid .c { text-align:center; } table.fm-grid .r { text-align:right; white-space:nowrap; }
  table.fm-grid td.mut { color:var(--muted); } table.fm-grid td.mut b { color:var(--text); font-weight:600; }
  table.fm-grid td.none { color:#C3C7CE; }
  table.fm-grid .nm { font-weight:600; }
  .pill { display:inline-block; margin-left:8px; padding:0 7px; border-radius:6px; background:#FFF4D6; color:#8A5A00; font-size:11.5px; font-weight:600; line-height:18px; }
  .tag { display:inline-block; padding:0 7px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:18px; }
  .tag.amb { background:#E8F1FD; color:#1F5FBF; } .tag.stat { background:#F3EEFB; color:#6B3FA0; }
  .flag { display:inline-block; margin-right:3px; padding:0 6px; border-radius:6px; background:#E9F7EF; color:#1E7B43; font-size:11.5px; font-weight:600; line-height:18px; }
  .flag.off { background:#F5F6F8; color:#B0B5BD; text-decoration:line-through; }
  .fm-act { width:30px; height:28px; margin-left:2px; border:1px solid var(--border); border-radius:8px; background:#fff; color:#3C4250; cursor:pointer; }
  .fm-act:hover { background:#F5F6F8; }
  .fm-act.danger:hover { color:#A50F22; border-color:#F3C5CB; background:#FDECEE; }
  .fm-empty { padding:60px 20px; text-align:center; color:#9AA1AC; }
  .fm-empty .fa { display:block; font-size:36px; margin-bottom:10px; color:#D5D8DE; }

  /* поля ввода и окна */
  .fm-in { width:100%; height:32px; padding:0 10px; border:1px solid var(--border, #E6E8EC); border-radius:9px; background:#fff; font-size:13px; font-family:inherit; color:#1F2430; }
  textarea.fm-in { height:auto; min-height:60px; padding:8px 10px; resize:vertical; }
  .fm-l { display:block; margin:0 0 4px; font-size:12px; font-weight:600; color:#6B7280; }
  .fm-row { display:grid; gap:10px 12px; }
  .fm-chk { display:inline-flex; align-items:center; gap:7px; margin:0 14px 0 0; font-size:13px; font-weight:500; color:#1F2430; cursor:pointer; }
  .fm-chk input { margin:0; }
  .fm-overlay { position:fixed; inset:0; z-index:1050; display:none; align-items:center; justify-content:center; background:rgba(20,25,40,.35); }
  .fm-overlay.open { display:flex; }
  .fm-modal { width:640px; max-width:calc(100% - 32px); max-height:calc(100% - 60px); display:flex; flex-direction:column; background:#fff; border-radius:16px;
    box-shadow:0 20px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .fm-modal * { box-sizing:border-box; }
  .fm-modal-head { display:flex; align-items:center; gap:10px; padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .fm-modal-head h3 { margin:0; flex:1; font-size:15px; font-weight:700; }
  .fm-modal-head .sub { display:block; font-size:12.5px; font-weight:400; color:#6B7280; }
  .fm-x { width:28px; height:28px; border:0; border-radius:8px; background:none; color:#9AA1AC; cursor:pointer; }
  .fm-x:hover { background:#F1F2F4; color:#1F2430; }
  .fm-modal-body { padding:16px 18px; overflow:auto; display:flex; flex-direction:column; gap:14px; }
  .fm-modal-foot { display:flex; align-items:center; gap:8px; padding:10px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 16px 16px; }
  .fm-sec { font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; }
  .fm-err { display:none; padding:8px 12px; border-radius:9px; background:#FDECEE; color:#A50F22; font-size:13px; }
  .fm-hint { font-size:12px; color:#9AA1AC; }
</style>
<style>
  /* Переключатели в окнах: состояние (Активная / Пассивная) и флажки-кнопки */
  .fm-state { display:inline-flex; padding:2px; background:#F1F2F4; border-radius:10px; }
  .fm-state label { margin:0; cursor:pointer; }
  .fm-state input { position:absolute; opacity:0; pointer-events:none; }
  .fm-state span { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 14px; border-radius:8px; color:#6B7280; font-size:13px; font-weight:600; }
  .fm-state span::before { content:''; width:8px; height:8px; border-radius:50%; background:#C3C7CE; }
  .fm-state input:checked + span { background:#fff; color:#1F2430; box-shadow:0 1px 2px rgba(20,25,40,.1); }
  .fm-state input.a:checked + span::before { background:#2E9E62; }
  .fm-state input.p:checked + span::before { background:#9AA1AC; }
  .fm-tgls { display:flex; flex-wrap:wrap; gap:8px; }
  .fm-tgl { margin:0; cursor:pointer; }
  .fm-tgl input { position:absolute; opacity:0; pointer-events:none; }
  .fm-tgl span { display:inline-flex; align-items:center; gap:7px; height:32px; padding:0 12px; border:1px solid #E6E8EC; border-radius:9px; background:#fff;
    color:#3C4250; font-size:13px; font-weight:500; user-select:none; }
  .fm-tgl span::before { content:'\f00c'; font-family:FontAwesome; font-size:11px; width:16px; height:16px; display:inline-flex; align-items:center; justify-content:center;
    border:1px solid #C9CDD5; border-radius:5px; color:transparent; }
  .fm-tgl:hover span { border-color:#C9CDD5; }
  .fm-tgl input:checked + span { border-color:#1F2430; background:#F5F6F8; color:#1F2430; font-weight:600; }
  .fm-tgl input:checked + span::before { background:#1F2430; border-color:#1F2430; color:#fff; }
  .fm-tgl input:focus-visible + span { box-shadow:0 0 0 3px rgba(75,85,99,.18); }
  .fm-modal-head .fm-state { margin-left:auto; }
</style>
