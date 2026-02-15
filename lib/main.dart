import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/detection/detection_bloc.dart';
import 'blocs/history/history_bloc.dart';
import 'blocs/info/info_bloc.dart';
import 'repositories/ml_repository.dart';
import 'repositories/disease_info_repository.dart';
import 'repositories/location_repository.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const DermatoLabApp());
}

class DermatoLabApp extends StatelessWidget {
  const DermatoLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => MLRepository()),
        RepositoryProvider(create: (context) => DiseaseInfoRepository()),
        RepositoryProvider(create: (context) => LocationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DetectionBloc(mlRepository: context.read<MLRepository>()),
          ),
          BlocProvider(create: (context) => HistoryBloc()),
          BlocProvider(
            create: (context) => InfoBloc(
              diseaseInfoRepository: context.read<DiseaseInfoRepository>(),
            )..add(LoadDiseaseInfo()),
          ),
        ],
        child: MaterialApp(
          title: 'DermatoLab',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
              brightness: Brightness.light,
            ),
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: AppColors.backgroundColor,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
