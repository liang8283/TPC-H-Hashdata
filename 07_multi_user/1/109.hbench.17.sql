set role hbench;
set search_path=tpch,public;
:EXPLAIN_ANALYZE
--begin q17
-- $ID$
-- TPC-H/TPC-R Small-Quantity-Order Revenue Query (Q17)
-- Functional Query Definition
-- Approved February 1998


select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
	lineitem,
	part
where
	p_partkey = l_partkey
	and p_brand = 'Brand#41'
	and p_container = 'LG PACK'
	and l_quantity < (
		select
			0.2 * avg(l_quantity)
		from
			lineitem
		where
			l_partkey = p_partkey
	);
--end q17
