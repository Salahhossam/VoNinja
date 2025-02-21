import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/lessons_page/exam_cubit/exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit() : super(ExamInitial());
  static ExamCubit get(context) {
    return BlocProvider.of(context);
  }

}
