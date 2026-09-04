import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/home_bloc.dart';
import 'home_body_widget.dart';
import 'home_body_without_map.dart';

class HomeBodyMainWidget extends StatelessWidget {
  final HomeBloc home;

  const HomeBodyMainWidget({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();

        return (homeBloc.isHomeLayoutSelected == "morden_layout")
            ? HomeBodyWithoutMap(home: home) // ✅ NEW UI
            : HomeBodyWidget(home: home); // ✅ OLD UI
      },
    );
  }
}
