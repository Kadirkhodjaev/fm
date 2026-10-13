-- Иконки ролей (страница выбора роли, roles.jsp). Font Awesome 4.2. Выполнить один раз на продакшене и у себя.
update roles set icon = 'fa fa-cogs'              where id = 1;  -- Администрирование
update roles set icon = 'fa fa-line-chart'        where id = 2;  -- Мониторинг
update roles set icon = 'fa fa-pencil-square-o'   where id = 3;  -- Приемное – медсестра
update roles set icon = 'fa fa-sign-in'           where id = 4;  -- Приемное – врач
update roles set icon = 'fa fa-user-md'           where id = 5;  -- Лечащий врач
update roles set icon = 'fa fa-hospital-o'        where id = 6;  -- Главный врач
update roles set icon = 'fa fa-flask'             where id = 7;  -- КДО
update roles set icon = 'fa fa-moon-o'            where id = 8;  -- Дежурный врач
update roles set icon = 'fa fa-comments'          where id = 9;  -- Консультация
update roles set icon = 'fa fa-plus-square'       where id = 10; -- Аптека
update roles set icon = 'fa fa-bell'              where id = 11; -- Постовой
update roles set icon = 'fa fa-cutlery'           where id = 12; -- Питание
update roles set icon = 'fa fa-money'             where id = 13; -- Касса
update roles set icon = 'fa fa-stethoscope'       where id = 14; -- Амбулаторные услуги
update roles set icon = 'fa fa-clipboard'         where id = 15; -- Амбулаторная регистрация
update roles set icon = 'fa fa-bolt'              where id = 16; -- Физиотерапия
update roles set icon = 'fa fa-calendar'          where id = 17; -- Бронирование
update roles set icon = 'fa fa-pie-chart'         where id = 18; -- Расходы по услугам
update roles set icon = 'fa fa-cubes'             where id = 19; -- Склады
update roles set icon = 'fa fa-file-text-o'       where id = 20; -- Акты
update roles set icon = 'fa fa-area-chart'        where id = 21; -- Мониторинг
update roles set icon = 'fa fa-clipboard'         where id = 22; -- Амб. рег. - НЮ
update roles set icon = 'fa fa-stethoscope'       where id = 23; -- Амб. услуги - НЮ
update roles set icon = 'fa fa-money'             where id = 24; -- Касса - НЮ
update roles set icon = 'fa fa-thumb-tack'        where id = 25; -- Иглотерапия
update roles set icon = 'fa fa-users'             where id = 26; -- Сотрудники
update roles set icon = 'fa fa-briefcase'         where id = 27; -- Руководство
