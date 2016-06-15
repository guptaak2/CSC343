let $resumeskills := (for $rskill in fn:doc("resume.xml")//skill
     return $rskill)
let $postingskills := (for $rskill in fn:doc("posting.xml")//reqSkill
     return $rskill)

let $d := (for $reqskill in $postingskills 
where not(some $r in $resumeskills satisfies $r/@what = $reqskill/@what
and $r/@level >= $reqskill/@level) 
return for $i in $reqskill/..//@pID, $j in $reqskill/@what
        return <problemposting pID = "{data($i)}">
        <skill what = "{data($j)}"/>
        </problemposting>)

return <missingskills>
	{$d}
	</missingskills>

