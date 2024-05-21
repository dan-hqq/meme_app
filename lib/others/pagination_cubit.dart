import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationCubit extends Cubit<int> {
  PaginationCubit() : super(1);

  void nextPage() => emit(state + 1);
}
