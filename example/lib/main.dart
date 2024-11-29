import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter.dart';
import 'package:one_loyalty_data_flutter_example/mission/mission_cubit.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_loyalty_data_flutter_example/user_loyalty/user_loyalty_cubit.dart';

final _oneLoyaltyDataFlutterPlugin = OneLoyaltyDataFlutter();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupSDK();
  runApp(const MyApp());
}

Future<void> _setupSDK() async {
  try {
    Map<String, dynamic> map = {
      "clientId": "oneloyalty-app",
      "apiKey": "oneloyalty-dev-oekao9roNahpat6sho2zua1ieghai1eishae4ua",
      "apiTokenKey": "onlala-app-api-key-dev",
      "apiClientIdKey": "X-Client-Id",
    };

  final result = await _oneLoyaltyDataFlutterPlugin.setupSDK(map);
    print("_setupSDK: ${result}"); // Output: SDK Setup Called
  } on PlatformException catch (e) {
    print("flutter _setupSDK. to setup SDK: '${e.message}");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MissionCubit>(
            create: (BuildContext context) => MissionCubit(),
          ),
          BlocProvider<UserLoyaltyCubit>(
            create: (BuildContext context) => UserLoyaltyCubit(),
          ),
        ],
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final missionCubit = context.read<MissionCubit>();
    final userLoyaltyCubit = context.read<UserLoyaltyCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const ElevatedButton(
                  onPressed: _setupSDK,
                  child: Text('Setup'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: missionCubit.fetchMissions,
                    child: const Text('Fetch Missions'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: userLoyaltyCubit.fetchUserLoyalty,
                    child: const Text('Fetch User'),
                  ),
                )
              ],
            ),
            BlocBuilder<UserLoyaltyCubit, UserLoyaltyState>(
              builder: (context, state) {
                if(state is UserLoyaltyLoading){
                  return const CircularProgressIndicator();
                } else if (state is UserLoyaltyLoaded) {
                  return Text("Coin: ${state.user["coinBalance"].toString()} ####### Point: ${state.user["pointBalance"].toString()}");
                } else if (state is UserLoyaltyError) {
                  return Text('Error: ${state.message}');
                }
                return Container();
              },
            ),
            BlocBuilder<MissionCubit, MissionState>(
              builder: (context, state) {
                if (state is MissionLoading) {
                  return const CircularProgressIndicator();
                } else if (state is MissionLoaded) {
                  // return Text("size of mission ${state.missions.length}");
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.missions.length,
                      itemBuilder: (context, index) {
                        final mission = state.missions[index];
                        return ListTile(
                          title: Text(mission["name"]),
                          subtitle: Text('type: ${mission["type"]}'),
                        );
                      },
                    ),
                  );
                } else if (state is MissionError) {
                  return Text('Error: ${state.message}');
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

