with cte_balance_money as (
    select c.id,
           c.name as currency_name,
           (select rate_to_usd
            from currency
            where updated in (select max(updated) from currency)
              and b.currency_id = id) as rate_to_usd
    from balance b
    inner join currency c on c.id = b.currency_id
    GROUP BY c.id, currency_name, b.currency_id
)

select coalesce(u.name, 'not defined') as name,
       coalesce(u.lastname, 'not defined') as lastname,
       b.type as type,
       sum(coalesce(b.money, 1)) as volume,
       coalesce(c.currency_name, 'not defined') as currency_name,
       coalesce(c.rate_to_usd, 1) as last_rate_to_usd,
       sum(coalesce(b.money, 1) * coalesce(c.rate_to_usd, 1)) as total_volume_in_usd
from "user" u
full join balance b on u.id = b.user_id
left join cte_balance_money c on c.id = b.currency_id
group by type, name, lastname, currency_name, last_rate_to_usd
order by name desc, lastname asc, type asc;

