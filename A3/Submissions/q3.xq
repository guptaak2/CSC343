<priorities> 
{
for $posting in doc("posting.xml")//posting
let $c := max($posting/reqSkill//@importance)
let $d := ($posting/reqSkill[@importance = $c])
return  <posting pID = "{data($d/../@pID)}">
	{for $i in $d
	return <skill importance = "{data($i//@importance)}">{data($i//@what)}</skill>
	}
	</posting>
}
</priorities>
