<%@ page import="rundeck.Execution; com.dtolabs.rundeck.server.authorization.AuthConstants" %>

<g:set var="ukey" value="${g.rkey()}"/>
        <div class="jobslist ${small?'small':''}">
                <g:if test="${jobslist.size()>0}">
                <table cellpadding="0" cellspacing="0" class="jobsList list" >
                    <g:if test="${null==headers || headers}">
                <tr>
                    <g:if test="${sortEnabled}">

                        <g:sortableColumn property="jobName" defaultOrder="desc" title="Name" colspan="2"  params="${paginateParams}"/>
                        <g:sortableColumn property="nextExecution" defaultOrder="desc" title="Execution" colspan="1" params="${paginateParams}"/>
                    </g:if>
                    <g:else>

                        <th colspan="2">Name</th>
                        <th colspan="1">Execution</th>
                    </g:else>
                </tr>
                        </g:if>
                    <% def j=0 %>
                    <g:each in="${runAuthRequired?jobslist.findAll{ jobauthorizations&&jobauthorizations[AuthConstants.ACTION_RUN]?.contains(it.id.toString())}:jobslist}" var="scheduledExecution">
                        <g:set var="nextExecution"
                               value="${ (nextExecutions)? nextExecutions[scheduledExecution.id] : null}"/>
                        <g:set var="clusterUUID"
                               value="${ (clusterMap)? clusterMap[scheduledExecution.id] : null}"/>
                        <g:set var="currentTime" value="${new Date()}"/>
                        <g:if test="${jobsjscallback}">
                            <tr class=" expandComponentHolder expanded" id="jobrow_${scheduledExecution.id}">
                               <td class="jobname">
                                   <div style="overflow:hidden; text-overflow: ellipsis; height:16px;">
                                       <g:set var="jstext" value="jobChosen('${enc(js: scheduledExecution.jobName)}','${enc(js: scheduledExecution.groupPath)}')"/>
                                       <span class="action textbtn" title="Choose this job" onclick="${enc(attr:jstext)}"><g:enc>${scheduledExecution.jobName}</g:enc></span>

                                       <span class="jobdesc" title="${enc(attr:scheduledExecution.description)}"><g:enc>${scheduledExecution.description}</g:enc></span>
                                   </div>
                               </td>
                            </tr>
                        </g:if>
                        <g:else>
                        <tr class="sectionhead expandComponentHolder ${paginateParams?.idlist==scheduledExecution.id.toString()?'expanded':''}" id="jobrow_${scheduledExecution.id}">
                            <td class="jobname">
                                    <span class="jobbulkeditfield" style="display: none">
                                    <g:if test="${jobauthorizations && jobauthorizations[AuthConstants.ACTION_DELETE]?.contains(scheduledExecution.id.toString())}">
                                        <input type="checkbox" name="ids" value="${enc(attr:scheduledExecution.extid)}"/>
                                    </g:if>
                                    <g:else>
                                        <span class="info note" style="width:12px;margin: 3px;"
                                              title="${message(code: 'unauthorized.job.delete',default: 'Not authorized to delete this job')}"><img
                                                src="${resource(dir: 'images', file: 'icon-tiny-warn.png')}" alt=""
                                                width="12px" height="12px"/></span>
                                    </g:else>
                                </span>
                                    <span class="inlinebuttons jobbuttons">
                                        <g:if test="${jobauthorizations && jobauthorizations[AuthConstants.ACTION_RUN]?.contains(scheduledExecution.id.toString())}">
                                            <g:link controller="scheduledExecution" action="execute"
                                                    id="${scheduledExecution.extid}" class=" btn btn-default btn-xs has_tooltip"
                                                    params="[project: scheduledExecution.project]"
                                                    data-toggle="tooltip"
                                                    title="Choose options and Run Job…"
                                                    data-job-id="${scheduledExecution.extid}"
                                                    onclick="if(typeof(loadExec)=='function'){loadExec(${scheduledExecution.id});return false;}">
                                                <b class="glyphicon glyphicon-play"></b>
                                            </g:link>
                                        </g:if>
                                    </span>

                                    <g:link action="show" controller="scheduledExecution" id="${scheduledExecution.extid}"
                                            params="[project: scheduledExecution.project]">
                                        <g:if test="${showIcon}">
                                            <i class="glyphicon glyphicon-book"></i>
                                        </g:if>
                                        <g:enc>${scheduledExecution.jobName}</g:enc>
                                    </g:link>

                                <g:if test="${jobauthorizations && jobauthorizations[AuthConstants.ACTION_UPDATE]?.contains(scheduledExecution.id.toString())}">
                                    <g:link action="edit" controller="scheduledExecution"
                                            params="[project: scheduledExecution.project]"
                                            id="${scheduledExecution.extid}"
                                            class="jobIdLink textbtn textbtn-info textbtn-on-hover"
                                            data-job-id="${scheduledExecution.extid}">
                                        <i class="glyphicon glyphicon-edit"></i>
                                        edit</g:link>
                                </g:if>

                                <span class="text-muted" title="${enc(attr:scheduledExecution.description)}"><g:enc>${scheduledExecution.description}</g:enc></span>

                            </td>
                            <td class="scheduletime">
                                <g:if test="${scheduledExecution.scheduled && nextExecution}">
                                    <i class="glyphicon glyphicon-time"></i>
                                    <span title="${remoteClusterNodeUUID ? g.message(code: "expecting.another.cluster.server.to.run") : ''} at ${g.relativeDate(atDate: nextExecution)}">
                                        <g:relativeDate elapsed="${nextExecution}" untilClass="timeuntil"/>
                                    </span>
                                </g:if>
                                <g:elseif test="${scheduledExecution.scheduled && !nextExecution}">
                                    <span class="scheduletime willnotrun has_tooltip"
                                          title="${g.message(code: 'job.schedule.will.never.fire')}"
                                          data-toggle="tooltip"
                                          data-placement="auto left">
                                        <i class="glyphicon glyphicon-time"></i>
                                        <span class="detail"><g:message code="never"/></span>
                                    </span>
                                </g:elseif>
                            </td>
                        </tr>
                        </g:else>
                        <% j++ %>
                    </g:each>
                </table>
            </g:if>
                <g:else>
                <span class="note empty">None</span>
            </g:else>
                <g:if test="${total && max && total.toInteger() > max.toInteger() && max.toInteger() > 0 && !hideSummary}">
                    <span class="info note">Showing <g:enc>${jobslist.size()} of ${total}</g:enc></span>
                </g:if>
        </div>
