<collegiality>
{
for $interview in doc("interview.xml")//interviews/interview
where $interview/@sID = $interview/../interviewer/@sID
	and not(exists($interview//collegiality))
return <forgot sid = "{data($interview/@sID)}"/> 
}
</collegiality>



