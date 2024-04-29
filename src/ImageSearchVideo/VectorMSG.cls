Class ImageSearchVideo.VectorMSG Extends %Persistent
{

Property VideoName As %String;

Property ImageName As %String;

Property ImageVector As %String;

Property TimeS As %String;

Storage Default
{
<Data name="VectorMSGDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VideoName</Value>
</Value>
<Value name="3">
<Value>VideoVector</Value>
</Value>
<Value name="4">
<Value>Time</Value>
</Value>
<Value name="5">
<Value>ImageName</Value>
</Value>
<Value name="6">
<Value>ImageVector</Value>
</Value>
<Value name="7">
<Value>TimeS</Value>
</Value>
</Data>
<DataLocation>^ImageSearchVideo.VectorMSGD</DataLocation>
<DefaultData>VectorMSGDefaultData</DefaultData>
<IdLocation>^ImageSearchVideo.VectorMSGD</IdLocation>
<IndexLocation>^ImageSearchVideo.VectorMSGI</IndexLocation>
<StreamLocation>^ImageSearchVideo.VectorMSGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

