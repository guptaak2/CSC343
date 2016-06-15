<DEALS>
{for $rent in doc("property.xml")//RENT_AMOUNT
where $rent <= 800
return	
	<DEAL>
	{data($rent)}
	</DEAL>
}</DEALS>

