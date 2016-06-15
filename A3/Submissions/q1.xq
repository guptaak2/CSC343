<skilled>
{
for $i in doc("resume.xml")//resume
where count($i//skills/skill) > 3
return  <candidate rid = "{data($i/@rID)}" numskills = "{count($i//skills/skill)}">
	<name>{data($i//forename)}</name>
	</candidate>
}
</skilled>
