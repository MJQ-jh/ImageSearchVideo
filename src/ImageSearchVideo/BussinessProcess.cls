/// 
Class ImageSearchVideo.BussinessProcess Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<call name='call bo' target='ImageSearchVideo.BO' async='0' xpos='200' ypos='250' >
<request type='ImageSearchVideo.request' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" languageOverride="" />
</response>
</call>
</sequence>
</process>
}

}

