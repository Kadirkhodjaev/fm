-- Стартовые страницы ролей (Roles.url): открываются после выбора роли, если CApp не задал свою.
-- Те же адреса, что раньше стояли в CApp. Выполнить один раз на продакшене (у себя уже выполнено).
update roles set url = '/core/user/list.s'      where id = 1;  -- Администрирование
update roles set url = '/reg/nurse/index.s'     where id = 3;  -- Приемное – медсестра
update roles set url = '/patients/list.s'       where id = 4;  -- Приемное – врач
update roles set url = '/patients/list.s'       where id = 5;  -- Лечащий врач
update roles set url = '/patients/list.s'       where id = 6;  -- Главный врач
update roles set url = '/patients/list.s'       where id = 7;  -- КДО
update roles set url = '/patients/list.s'       where id = 8;  -- Дежурный врач
update roles set url = '/patients/consul.s'     where id = 9;  -- Консультация
update roles set url = '/drugs/acts.s'          where id = 10; -- Аптека
update roles set url = '/patients/list.s'       where id = 11; -- Постовой
update roles set url = '/eats/menu.s'           where id = 12; -- Питание
update roles set url = '/amb/home.s'            where id = 13; -- Касса
update roles set url = '/amb/home.s'            where id = 14; -- Амбулаторные услуги
update roles set url = '/amb/reg.s'             where id = 15; -- Амбулаторная регистрация
update roles set url = '/patients/list.s'       where id = 16; -- Физиотерапия
update roles set url = '/patients/list.s'       where id = 17; -- Бронирование
update roles set url = '/exp/stat.s'            where id = 18; -- Расходы по услугам
update roles set url = '/head_nurse/incomes.s'  where id = 19; -- Склады
update roles set url = '/act/index.s'           where id = 20; -- Акты
update roles set url = '/cashbox/statistic.s'   where id = 21; -- Мониторинг
update roles set url = '/ambs/reg.s'            where id = 22; -- Амб. рег. - НЮ
update roles set url = '/ambs/patients.s'       where id = 23; -- Амб. услуги - НЮ
update roles set url = '/ambs/patients.s'       where id = 24; -- Касса - НЮ
update roles set url = '/patients/list.s'       where id = 25; -- Иглотерапия
update roles set url = '/emp/index.s'           where id = 26; -- Сотрудники
update roles set url = '/boss.s'                where id = 27; -- Руководство
