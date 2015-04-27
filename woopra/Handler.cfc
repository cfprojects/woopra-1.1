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

<cfcomponent>

	<cfset variables.package = "com/sebduggan/mango/plugins/woopra"/>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
			<cfset var blogid = arguments.mainManager.getBlog().getId() />
			<cfset var path = blogid & "/" & variables.package />
			<cfset variables.preferencesManager = arguments.preferences />
			<cfset variables.manager = arguments.mainManager />
			<cfset variables.autotag = variables.preferencesManager.get(path,"autotag","1") />
			<cfset variables.logComments = variables.preferencesManager.get(path,"comments","1") />
			
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>
	
	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "Woopra plugin activated. Would you like to <a href='generic_settings.cfm?event=showWoopraSettings&amp;owner=woopra&amp;selected=showWoopraSettings'>configure it now</a>?" />
	</cffunction>
	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

			<cfset var js = "" />
			<cfset var obj = "" />
			<cfset var outputData = "" />
			<cfset var link = "" />
			<cfset var page = "" />
			<cfset var data = ""/>
			<cfset var path = "" />
			<cfset var admin = "" />
			<cfset var eventName = arguments.event.name />
			
			
			<cfif eventName EQ "afterCommentAdd">
				<cfset obj = arguments.event.getNewItem() />
				
				<!--- If a comment's been posted, pass the info to Woopra --->
				<cfif variables.autotag>
					<cfset request.woopraData.name = obj.getCreatorName() />
					<cfset request.woopraData.email = obj.getCreatorEmail() />
				</cfif>
				<cfif variables.logComments>
					<cfset request.woopraData.content = obj.getContent() />
					
					<cfif len(request.woopraData.content) gt 100>
						<cfset request.woopraData.content = Left(request.woopraData.content, 100) & "..." />
					</cfif>
				</cfif>
				
			<cfelseif eventName EQ "beforeHtmlBodyEnd">
				<cfset outputData =  arguments.event.getOutputData() />
				
				<!--- Get stored data --->
					
<cfsavecontent variable="js"><cfoutput>
<!-- Woopra Code Start -->
<script type="text/javascript">
<cfif StructKeyExists(request,"woopraData")><cfif variables.autotag>
var woopra_visitor = new Array();
woopra_visitor['name'] = '#JSStringFormat(request.woopraData.name)#';
woopra_visitor['email'] = '#JSStringFormat(request.woopraData.email)#';
woopra_visitor['avatar'] = 'http://www.gravatar.com/avatar.php?gravatar_id=#LCase(Hash(Lcase(request.woopraData.email)))#&size=60&default=http%3A%2F%2Fstatic.woopra.com%2Fimages%2Favatar.png';
</cfif><cfif variables.logComments>
var woopra_event = new Array();
woopra_event['Comment'] = '#JSStringFormat(request.woopraData.content)#';
</cfif></cfif>var _wh = ((document.location.protocol=='https:') ? "https://sec1.woopra.com" : "http://static.woopra.com");
document.write(unescape("%3Cscript src='" + _wh + "/js/woopra.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<!-- Woopra Code End -->
</cfoutput></cfsavecontent>
				<cfset arguments.event.setOutputData(outputData & js) />
							
			<!--- admin nav event --->
			<cfelseif eventName EQ "settingsNav">
				<cfset link = structnew() />
				<cfset link.owner = "woopra">
				<cfset link.page = "settings" />
				<cfset link.title = "Woopra" />
				<cfset link.eventName = "showWoopraSettings" />
				
				<cfset arguments.event.addLink(link)>
			
			<!--- admin event --->
			<cfelseif eventName EQ "showWoopraSettings">
				<cfset data = arguments.event.getData() />				
				<cfif structkeyexists(data.externaldata,"apply")>
					<cfparam name="data.externaldata.autotag" default="0" />
					<cfparam name="data.externaldata.logComments" default="0" />
					
					<cfset variables.autotag = data.externaldata.autotag />
					<cfset variables.logComments = data.externaldata.logComments />
					
					<cfset path = variables.manager.getBlog().getId() & "/" & variables.package />
					<cfset variables.preferencesManager.put(path,"autotag",variables.autotag) />
					<cfset variables.preferencesManager.put(path,"logComments",variables.logComments) />
					
					<!--- this is a hack, just try to get the currently authenticated user --->
					<cftry>
						<cfif structkeyexists(session,"author")>
							<cfset variables.manager.getAdministrator().pluginUpdated(
									"woopra", variables.id, session.author) />
						</cfif>
						<cfcatch type="any"></cfcatch>
					</cftry>
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("Woopra settings updated")/>
				</cfif>
				
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
					
					<!--- change message --->
					<cfset data.message.setTitle("Woopra settings") />
					<cfset data.message.setData(page) />
			</cfif>
		
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>