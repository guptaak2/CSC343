let $postingSkills := (
for $skillName in doc("posting.xml")//reqSkill/@what
	return $skillName
)

let $resumeSkills := (
for $skill in doc("resume.xml")//skill
	return $skill
)

let $skillsRequired := distinct-values($postingSkills)

let $skillNameAndLevelCount := (
for $skill in $skillsRequired
	return
	<skill name = "{data($skill)}">
        {
	for $level in (1 to 5)
	return 
	<count level = "{data($level)}"
	n = "{data(count($resumeSkills[@what = $skill and @level = $level]))}"/>}
	</skill>
	)
return 
        <histogram>
                {$skillNameAndLevelCount}
        </histogram>
