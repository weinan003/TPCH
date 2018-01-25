\timing
analyze nation; analyze region;analyze part;analyze supplier;analyze partsupp;analyze customer;analyze orders;analyze lineitem;
\timing off
select '***', 'vacuum.sql', sess_id from pg_stat_activity where current_query like '%vacuum.sql%';