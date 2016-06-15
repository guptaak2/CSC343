let $halfResumeCount := count(fn:doc("resume.xml")//resume) * 0.5

let $includeSkillAbove3 := (for $posting in doc("posting.xml")//posting
	where some $reqSkill in $posting/reqSkill satisfies $halfResumeCount >  
	count(for $resume in doc("resume.xml")//resume
		where some $rskill in $resume/skills/skill 
		satisfies $rskill/@what = $reqSkill/@what and data($rskill/@level) > 3
	return $resume/@rID)
return  for $i in $posting/@pID, $j in $posting//@what
	return <posting pID = "{$i}" 
	skill = "{$j}"
	numwith = "{count(for $resume in doc("resume.xml")//resume
                where some $rskill in $resume/skills/skill
                satisfies $rskill/@what = $j return $resume/@rID)}"
	numhigh = "{count(for $resume in doc("resume.xml")//resume
                where some $rskill in $resume/skills/skill
                satisfies $rskill/@what = $j and data($rskill/@level) > 3 
		return $resume/@rID)}"/>)

return <rareskills numresumes = "{$halfResumeCount * 2}">
        {$includeSkillAbove3}
        </rareskills>
