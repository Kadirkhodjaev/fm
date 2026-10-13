-- Продакшен, обновление 13.10.2026: настройки ролей. Выполнять ПОСЛЕ выкладки и запуска приложения
-- (колонки roles.showMenu и roles.showSearch создаёт само приложение при старте).
-- Значения взяты из локальной базы, где они настроены. Повторный запуск безопасен.

-- Иконки, стартовые страницы, показ меню в карточке пациента (showMenu) и поиска пациента в шапке (showSearch)
update roles set icon = 'fa fa-cogs', url = '/core/user/list.s', showMenu = 'N', showSearch = 'N' where id = 1;  -- Администрирование
update roles set icon = 'fa fa-line-chart', url = '/rep/home.s', showMenu = 'N', showSearch = 'Y' where id = 2;  -- Мониторинг
update roles set icon = 'fa fa-pencil-square-o', url = '/reg/nurse/index.s', showMenu = 'Y', showSearch = 'Y' where id = 3;  -- Приемное – медсестра
update roles set icon = 'fa fa-sign-in', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 4;  -- Приемное – врач
update roles set icon = 'fa fa-user-md', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 5;  -- Лечащий врач
update roles set icon = 'fa fa-hospital-o', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 6;  -- Главный врач
update roles set icon = 'fa fa-flask', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 7;  -- КДО
update roles set icon = 'fa fa-moon-o', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 8;  -- Дежурный врач
update roles set icon = 'fa fa-comments', url = '/patients/consul.s', showMenu = 'N', showSearch = 'Y' where id = 9;  -- Консультация
update roles set icon = 'fa fa-plus-square', url = '/drugs/acts.s', showMenu = 'N', showSearch = 'N' where id = 10;  -- Аптека
update roles set icon = 'fa fa-bell', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 11;  -- Постовой
update roles set icon = 'fa fa-cutlery', url = '/eats/menu.s', showMenu = 'N', showSearch = 'Y' where id = 12;  -- Питание
update roles set icon = 'fa fa-money', url = '/amb/home.s', showMenu = 'Y', showSearch = 'Y' where id = 13;  -- Касса
update roles set icon = 'fa fa-stethoscope', url = '/amb/home.s', showMenu = 'Y', showSearch = 'Y' where id = 14;  -- Амбулаторные услуги
update roles set icon = 'fa fa-clipboard', url = '/amb/reg.s', showMenu = 'Y', showSearch = 'Y' where id = 15;  -- Амбулаторная регистрация
update roles set icon = 'fa fa-bolt', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 16;  -- Физиотерапия
update roles set icon = 'fa fa-calendar', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 17;  -- Бронирование
update roles set icon = 'fa fa-pie-chart', url = '/exp/stat.s', showMenu = 'N', showSearch = 'Y' where id = 18;  -- Расходы по услугам
update roles set icon = 'fa fa-cubes', url = '/head_nurse/incomes.s', showMenu = 'N', showSearch = 'Y' where id = 19;  -- Склады
update roles set icon = 'fa fa-file-text-o', url = '/act/index.s', showMenu = 'N', showSearch = 'Y' where id = 20;  -- Акты
update roles set icon = 'fa fa-area-chart', url = '/cashbox/statistic.s', showMenu = 'N', showSearch = 'Y' where id = 21;  -- Мониторинг
update roles set icon = 'fa fa-clipboard', url = '/ambs/reg.s', showMenu = 'Y', showSearch = 'N' where id = 22;  -- Амб. рег. - НЮ
update roles set icon = 'fa fa-stethoscope', url = '/ambs/patients.s', showMenu = 'Y', showSearch = 'N' where id = 23;  -- Амб. услуги - НЮ
update roles set icon = 'fa fa-money', url = '/ambs/patients.s', showMenu = 'Y', showSearch = 'N' where id = 24;  -- Касса - НЮ
update roles set icon = 'fa fa-thumb-tack', url = '/patients/list.s', showMenu = 'N', showSearch = 'Y' where id = 25;  -- Иглотерапия
update roles set icon = 'fa fa-users', url = '/emp/index.s', showMenu = 'N', showSearch = 'N' where id = 26;  -- Сотрудники
update roles set icon = 'fa fa-briefcase', url = '/boss.s', showMenu = 'N', showSearch = 'Y' where id = 27;  -- Руководство

-- По желанию: дата создания у старых назначений (lv_plans.crOn пустая), чтобы отчёты по дате создания их видели.
-- Новые назначения получают crOn автоматически. Раскомментировать, если нужно:
-- update lv_plans set crOn = actDate where crOn is null;
