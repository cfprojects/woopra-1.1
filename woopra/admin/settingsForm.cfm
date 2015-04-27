<!--- 
Project:     Woopra plugin for Mango Blog <http://mangoblog.org>Author:      Seb Duggan <seb@sebduggan.com>Version:     1.1Build date:  2009-02-03 10:06:48Check for updated versions at <http://code.google.com/p/mangoplugins/>


Copyright 2009 Seb Duggan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->

<cfoutput>

<form method="post" action="#cgi.script_name#">
	<fieldset>
		<legend>Woopra</legend>
		
		<p>
			<input type="checkbox" id="autotag" name="autotag" value="1" <cfif variables.autotag>checked="checked"</cfif>/>
			<label for="autotag">Auto tag visitors</label>
			<span class="hint">Tag visitors' name when they post a comment</span>
		</p>
	
		<p>
			<input type="checkbox" id="logComments" name="logComments" value="1" <cfif variables.logComments>checked="checked"</cfif>/>
	    	<label for="logComments">Show comments as they are posted</label>
			<span class="hint">You will see an excerpt of the comment in the Woopra Live section</span>
		</p>
	</fieldset>
	
	<div class="actions">
		<input type="submit" class="primaryAction" value="Submit"/>
		<input type="hidden" value="event" name="action" />
		<input type="hidden" value="showWoopraSettings" name="event" />
		<input type="hidden" value="true" name="apply" />
		<input type="hidden" value="woopra" name="selected" />
	</div>

</form>

</cfoutput>