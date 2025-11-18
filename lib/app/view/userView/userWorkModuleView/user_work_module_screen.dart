import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userWorkModuleView/user_team_module_screen.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class UserWorkModuleScreen extends StatefulWidget {
  const UserWorkModuleScreen({super.key});

  @override
  State<UserWorkModuleScreen> createState() => _UserWorkModuleScreenState();
}

class _UserWorkModuleScreenState extends State<UserWorkModuleScreen> {
  //late Future<ProjectTypeResponse?> futureProjectType;

  @override
  void initState() {
    super.initState();
    // futureProjectType = fetchAllProjectType();
    Future.microtask(() =>
        Provider.of<UserProjectProvider>(context, listen: false)
            .fatchAllProjectType());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projects")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserProjectProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                  child: Column(
                children: [
                  Text(describeApiError(provider.error!)),
                  ElevatedButton(
                      onPressed: () {
                        Provider.of<UserProjectProvider>(context, listen: false)
                            .fatchAllProjectType();
                      },
                      child: Text("Retry"))
                ],
              ));
            }

            if (provider.projectType == null) {
              return const Center(child: Text("No project type available."));
            }
            final project = provider.projectType!.data;
            final hasProject = project != null && project.isNotEmpty;
            return Center(
                child: Container(
                    child: RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<UserProjectProvider>(context,
                                  listen: false)
                              .fatchAllProjectType();
                        },
                        child: hasProject
                            ? ListView.builder(
                                itemCount: provider.projectType!.data!.length,
                                itemBuilder: (context, index) {
                                  final type =
                                      provider.projectType!.data![index];
                                  final typeUid = type.tnecProjectTypeUid;

                                  return Card(
                                    child: ExpansionTile(
                                      title: Text(
                                        type.tnecProjectTypeName,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onExpansionChanged: (expanded) {
                                        if (expanded &&
                                            !provider.userProjects
                                                .containsKey(typeUid)) {
                                          provider.fatchAllProjects(typeUid);
                                        }
                                      },
                                      children: [
                                        if (provider
                                                .isLoadingProjects[typeUid] ==
                                            true)
                                          const Center(
                                              child:
                                                  CircularProgressIndicator())
                                        else if (provider.userProjects
                                            .containsKey(typeUid))
                                          ...provider
                                              .userProjects[typeUid]!.data!
                                              .map((userProject) {
                                            final projectUid =
                                                userProject.tnecProjectUid;

                                            return ExpansionTile(
                                              title: Text(
                                                userProject.tnecProjectName,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              onExpansionChanged: (expanded) {
                                                if (expanded &&
                                                    !provider.projectTeams
                                                        .containsKey(
                                                            projectUid)) {
                                                  provider.fatchProjectTeam(
                                                      projectUid);
                                                }
                                              },
                                              children: [
                                                Text(
                                                  "Teams",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                if (provider.isLoadingTeams[
                                                        projectUid] ==
                                                    true)
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                else if (provider.projectTeams
                                                    .containsKey(projectUid))
                                                  ...provider
                                                      .projectTeams[projectUid]!
                                                      .data
                                                      .map((team) {
                                                    return ListTile(
                                                      title: Text(
                                                        team.teamName,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16),
                                                      onTap: () {
                                                        print(
                                                            "{$typeUid},${projectUid},${team.teamUid}");
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserProjectTeamScreen(
                                                                    teamName: team
                                                                        .teamName,
                                                                    projectUid:
                                                                        projectUid,
                                                                    teamUid: team
                                                                        .teamUid,
                                                                  )),
                                                        );
                                                      },
                                                    );
                                                  }).toList()
                                                else
                                                  const ListTile(
                                                    title:
                                                        Text("No teams found."),
                                                  )
                                              ],
                                            );
                                          }).toList()
                                        else
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child:
                                                Text("No projects available."),
                                          )
                                      ],
                                    ),
                                  );
                                },
                              )
                            : ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  const Icon(Icons.refresh,
                                      size: 40, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  const Center(
                                    child: Text(
                                      "Refresh & Load Tasks",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Center(
                                    child: Text(
                                      "No tasks found",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ))));
          },
        ),
      ),
    );
  }

  String describeApiError(ApiError error) {
    switch (error) {
      case ApiError.network:
        return "No internet connection.";
      case ApiError.timeout:
        return "Request timed out.";
      case ApiError.platform:
        return "Platform error.";
      case ApiError.client:
        return "Client error.";
      case ApiError.server:
        return "Server error.";
      case ApiError.jsonFormat:
        return "Invalid response format.";
      case ApiError.missingUUID:
        return "User ID not found.";
      case ApiError.unknown:
      default:
        return "An unknown error occurred.";
    }
  }
}
