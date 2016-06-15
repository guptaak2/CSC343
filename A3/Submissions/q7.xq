let $interviews := (
	for $interview in doc("interview.xml")//interview
		return $interview
)

let $returnInterview := (
	for $interview in $interviews
		let $posting := (
		for $postings in doc("posting.xml")//posting
			where $postings/@pID = $interview/@pID
			return $postings
		)

		let $resume := (
		for $resumes in doc("resume.xml")//resume
			where $resumes/@rID = $interview/@rID
			return $resumes
		)

		let $assessmentAverageScore := avg((
			$interview//assessment/collegiality,
			$interview//assessment/techProficiency,
			$interview//assessment/communication,
			$interview//assessment/enthusiasm,
			$interview//answer
		))

		let $skillsPossessed := (
			for $skill in $resume//skill
				return $skill/@what
		)

		let $degreeOfMatch := (
			for $posting_skill in $posting//reqSkill
			let $resume_skill := (
			for $_skill in $resume//skill
				where $posting_skill/@what = $_skill/@what
				return $_skill
			)
			return 
			if (exists(index-of($skillsPossessed, $posting_skill/@what)))
				then 
					if ($resume_skill/@level >= $posting_skill/@level)
						then $posting_skill/@importance
						else $posting_skill/@importance * -1
					else $posting_skill/@importance * -1
			)				
		let $sumDegreeOfMatch := sum($degreeOfMatch)
		return <interview>
			<who rID = "{string($interview/@rID)}" 
			forename = "{string($resume//forename)}" 
			surname = "{string($resume//surname)}"/>			
			<position>{string($posting/position)}</position>
			<match>{data($sumDegreeOfMatch)}</match>
			<average>{data($assessmentAverageScore)}</average>
			</interview>
)

return
	<report>{$returnInterview}</report>

