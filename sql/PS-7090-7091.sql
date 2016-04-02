set SQL_SAFE_UPDATES=0;
SET FOREIGN_KEY_CHECKS=0;

drop table emm_workflow_vehicle_version_hierarchy_approver;
drop table emm_workflow_vehicle_version_hierarchy;
drop table emm_workflow_vehicle_version_lock_approver;
drop table emm_workflow_vehicle_version_lock;
drop table emm_workflow_vehicle_version;
drop table emm_workflow_template_hierarchy_approver;
drop table emm_workflow_template_hierarchy;
drop table emm_workflow_template_lock_approver;
drop table emm_workflow_template_lock_dependency;
drop table emm_lock_dependency;
drop table emm_workflow_template_channel;
drop table emm_workflow_template;
drop table emm_workflow_lock_type;
drop table emm_organizational_role_user;
drop table emm_organizational_role;

create table if not exists emm_organizational_role (
    id int(4) NOT NULL AUTO_INCREMENT,
    name varchar(255),
    code_name varchar(255),
    delete_ts timestamp NULL,
    primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_organizational_role_user (
    id int(4) NOT NULL AUTO_INCREMENT,
    system_account_id int(11) NOT NULL,
    organizational_role_id int(4) NOT NULL,
    primary key (id),
    CONSTRAINT system_account_id_fk FOREIGN KEY (system_account_id) REFERENCES dms_system_account (system_account_id),
    CONSTRAINT organizational_role_id_fk FOREIGN KEY (organizational_role_id) REFERENCES emm_organizational_role (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_lock_type (
    id int(4) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    code_name varchar(50),
    create_ts timestamp NOT NULL,
    delete_ts timestamp NULL,
    primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_template (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    created_by int(11) NOT NULL,
    last_modified_by int(11),
    create_ts timestamp NOT NULL,
    update_ts timestamp NULL,
    delete_ts timestamp NULL,
    primary key (id),
    CONSTRAINT sys_id_fk5 FOREIGN KEY (created_by) REFERENCES dms_system_account (system_account_id),
    CONSTRAINT sys_id_fk6 FOREIGN KEY (last_modified_by) REFERENCES dms_system_account (system_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_template_channel (
    id int(11) NOT NULL AUTO_INCREMENT,
    workflow_id int(11) NOT NULL,
    channel_id int(11) NOT NULL,
    primary key (id),
    CONSTRAINT workflow_id_fk FOREIGN KEY (workflow_id) REFERENCES emm_workflow_template (id),
    CONSTRAINT channel_id_fk FOREIGN KEY (channel_id) REFERENCES rfps_channel(channel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_lock_dependency (
    id int(4) NOT NULL AUTO_INCREMENT,
    lock_type_id int (4) NOT NULL,
    organizational_role_id int(4) NOT NULL,
    primary key (id),
    CONSTRAINT lock_type_id_fk FOREIGN KEY (lock_type_id) REFERENCES emm_workflow_lock_type (id),
    CONSTRAINT organizational_role_id_fk1 FOREIGN KEY (organizational_role_id) REFERENCES emm_organizational_role (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_template_lock_dependency (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_id int(11) NOT NULL,
    lock_type_dependency_id int(4) NOT NULL,
    duration int(11),
    reminder_days int(3),
    primary key (id),
    CONSTRAINT workflow_id_fk1 FOREIGN KEY (workflow_id) REFERENCES emm_workflow_template (id),
    CONSTRAINT workflow_lock_type_dependency_id_fk FOREIGN KEY (lock_type_dependency_id) REFERENCES emm_lock_dependency (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_template_lock_approver (
    id int(11) NOT NULL AUTO_INCREMENT,
    workflow_lock_dependency_id int(4) NOT NULL,
    approver_id int(11) NOT NULL,
    primary key (id),
    CONSTRAINT workflow_lock_dependency_id_fk FOREIGN KEY (workflow_lock_dependency_id) REFERENCES emm_workflow_template_lock_dependency (id),
    CONSTRAINT sys_id_fk FOREIGN KEY (approver_id) REFERENCES dms_system_account (system_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_template_hierarchy (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_id int(11) NOT NULL,
    hierarchy_id int (11) NOT NULL,
    duration int(11),
    reminder_days int(3),
    primary key (id),
    CONSTRAINT workflow_id_fk2 FOREIGN KEY (workflow_id) REFERENCES emm_workflow_template (id),
    CONSTRAINT hierarchy_id_fk FOREIGN KEY (hierarchy_id) REFERENCES merchandise_hierarchy (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_template_hierarchy_approver (
    id int(11) NOT NULL AUTO_INCREMENT,
    workflow_hierarchy_id int(4) NOT NULL,
    approver_id int(11) NOT NULL,
    primary key (id),
    CONSTRAINT workflow_merchandise_hierarchy_id_fk FOREIGN KEY (workflow_hierarchy_id) REFERENCES emm_workflow_template_hierarchy (id),
    CONSTRAINT sys_id_fk1 FOREIGN KEY (approver_id) REFERENCES dms_system_account (system_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_vehicle_version (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_id int(11) NOT NULL,
    vehicle_version_id int (11) NOT NULL,
    last_modified_by int(11),
    create_ts timestamp NOT NULL,
    update_ts timestamp NULL,
    delete_ts timestamp NULL,
    primary key (id),
    CONSTRAINT workflow_id_fk3 FOREIGN KEY (workflow_id) REFERENCES emm_workflow_template (id),
    CONSTRAINT vehicle_version_id_fk FOREIGN KEY (vehicle_version_id) REFERENCES rfps_vehicle_version(vehicle_version_id),
    CONSTRAINT sys_id_fk3 FOREIGN KEY (last_modified_by) REFERENCES dms_system_account (system_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_vehicle_version_lock (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_vehicle_version_id int (11) NOT NULL,
    lock_type_dependency_id int(11) NOT NULL,
    lock_time timestamp NULL,
    reminder_days int(3),
    primary key (id),
    CONSTRAINT workflow_vehicle_version_id_fk FOREIGN KEY (workflow_vehicle_version_id) REFERENCES emm_workflow_vehicle_version (id),
    CONSTRAINT vehicle_version_lock_dependency_id_fk FOREIGN KEY (lock_type_dependency_id) REFERENCES emm_lock_dependency (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_vehicle_version_lock_approver (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_vehicle_version_lock_dependency_id int (11) NOT NULL,
    approver_id int(11) NOT NULL,
    primary key (id),
    CONSTRAINT workflow_vehicle_version_lock_dependency_id_fk FOREIGN KEY (workflow_vehicle_version_lock_dependency_id) REFERENCES emm_workflow_vehicle_version_lock (id),
    CONSTRAINT sys_id_fk2 FOREIGN KEY (approver_id) REFERENCES dms_system_account (system_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_vehicle_version_hierarchy (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_vehicle_version_id int (11) NOT NULL,
    hierarchy_id int (11) NOT NULL,
    lock_time timestamp NULL,
    reminder_days int(3),
    primary key (id),
    CONSTRAINT workflow_vehicle_version_id_fk1 FOREIGN KEY (workflow_vehicle_version_id) REFERENCES emm_workflow_vehicle_version (id),
    CONSTRAINT merchandise_hierarchy_id_fk FOREIGN KEY (hierarchy_id) REFERENCES merchandise_hierarchy (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table if not exists emm_workflow_vehicle_version_hierarchy_approver (
    id int (11) NOT NULL AUTO_INCREMENT,
    workflow_vehicle_version_hierarchy_id int (11) NOT NULL,
    approver_id int(11) NOT NULL,
    primary key (id),
    CONSTRAINT workflow_vehicle_version_hierarchy_id_fk FOREIGN KEY (workflow_vehicle_version_hierarchy_id) REFERENCES emm_workflow_vehicle_version_hierarchy (id),
    CONSTRAINT sys_id_fk4 FOREIGN KEY (approver_id) REFERENCES dms_system_account (system_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO emm_organizational_role(name, code_name) SELECT 'None', 'none' FROM dual WHERE NOT EXISTS (select * from emm_organizational_role where name = 'None');
INSERT INTO emm_organizational_role(name, code_name) SELECT 'Marketing Strategy', 'marketing-strategy' FROM dual WHERE NOT EXISTS (select * from emm_organizational_role where name = 'Marketing Strategy');
INSERT INTO emm_organizational_role(name, code_name) SELECT 'Marketing Operations', 'marketing-operations' FROM dual WHERE NOT EXISTS (select * from emm_organizational_role where name = 'Marketing Operations');
INSERT INTO emm_organizational_role(name, code_name) SELECT 'Category Marketing', 'category-marketing' FROM dual WHERE NOT EXISTS (select * from emm_organizational_role where name = 'Category Marketing');
INSERT INTO emm_organizational_role(name, code_name) SELECT 'Merchandising', 'merchandising' FROM dual WHERE NOT EXISTS (select * from emm_organizational_role where name = 'Merchandising');

INSERT INTO emm_workflow_lock_type(name, code_name, create_ts) SELECT 'Grid Plan', 'grid-plan', now() FROM dual WHERE NOT EXISTS (select * from emm_workflow_lock_type where name = 'Grid Plan');
INSERT INTO emm_workflow_lock_type(name, code_name, create_ts) SELECT 'Category Plan', 'category-plan', now() FROM dual WHERE NOT EXISTS (select * from emm_workflow_lock_type where name = 'Category Plan');
INSERT INTO emm_workflow_lock_type(name, code_name, create_ts) SELECT 'Item Plan', 'item-plan', now() FROM dual WHERE NOT EXISTS (select * from emm_workflow_lock_type where name = 'Item Plan');

alter table emm_workflow_template add column has_default_approver char(1) not null default 'N' after last_modified_by;

alter table emm_workflow_vehicle_version_lock_approver add column task_completed char(1) not null default 'N' after approver_id;
alter table emm_workflow_vehicle_version_hierarchy_approver add column task_completed char(1) not null default 'N' after approver_id;

alter table emm_workflow_vehicle_version_lock_approver add column assigned_time timestamp null after approver_id;
alter table emm_workflow_vehicle_version_hierarchy_approver add column assigned_time timestamp null after approver_id;

alter table emm_workflow_vehicle_version_lock add column notification_mail_sent char(1) not null default 'N' after reminder_days;
alter table emm_workflow_vehicle_version_lock add column reminder_mail_sent char(1) not null default 'N' after notification_mail_sent;


insert into emm_lock_dependency(lock_type_id, organizational_role_id) select lockType.id, orgRole.id
  from (select id from emm_workflow_lock_type where code_name = 'grid-plan') as lockType
  cross join (select id from emm_organizational_role where code_name = 'marketing-strategy') as orgRole;
insert into emm_lock_dependency(lock_type_id, organizational_role_id) select lockType.id, orgRole.id
  from (select id from emm_workflow_lock_type where code_name = 'category-plan') as lockType
  cross join (select id from emm_organizational_role where code_name = 'category-marketing') as orgRole;
insert into emm_lock_dependency(lock_type_id, organizational_role_id) select lockType.id, orgRole.id
  from (select id from emm_workflow_lock_type where code_name = 'item-plan') as lockType
  cross join (select id from emm_organizational_role where code_name = 'merchandising') as orgRole;

select @orgRoleId := id from emm_organizational_role where code_name = 'none';
insert into emm_organizational_role_user(system_account_id, organizational_role_id)
  select system_account_id, @orgRoleId from dms_system_account where account_deleted = 0 and expiry_date > unix_timestamp(now());

SET FOREIGN_KEY_CHECKS=1;
set SQL_SAFE_UPDATES=1;