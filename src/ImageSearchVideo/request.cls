Class ImageSearchVideo.request Extends Ens.Request
{

Property filename As %String;

Property fullurl As %String;

Storage Default
{
<Data name="requestDefaultData">
<Subscript>"request"</Subscript>
<Value name="1">
<Value>filename</Value>
</Value>
<Value name="2">
<Value>fullurl</Value>
</Value>
</Data>
<DefaultData>requestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

