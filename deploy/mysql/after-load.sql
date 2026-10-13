-- Выполняется db-load.ps1 после загрузки дампа в ЛОКАЛЬНУЮ базу (на продакшене не запускать).
-- Пароль у всех пользователей "1" (md5), отладочный режим, вход администратора под логином admin.
update users t set t.Password = 'C4CA4238A0B923820DCC509A6F75849B';
update params t set t.val = 'Y' Where t.code = 'IS_DEBUG';
update users t set t.login = 'admin' Where t.id = 1;
-- Флаги меню и поиска ролей (CApp читает их из Roles). Заполняются только пустые, заданные значения не трогаются.
-- showMenu = Y: левое меню видно и внутри карточки пациента; showSearch = Y: поиск пациента в шапке.
update roles set showMenu = Case When id In (3, 4, 7, 13, 14, 15, 22, 23, 24, 26) Then 'Y' Else 'N' End Where showMenu Is Null;
update roles set showSearch = Case When id In (1, 10, 22, 23, 24, 26) Then 'N' Else 'Y' End Where showSearch Is Null;
