import 'package:equatable/equatable.dart';

sealed class ExportState extends Equatable {
  const ExportState();

  @override
  List<Object?> get props => [];
}

final class ExportInitial extends ExportState {
  const ExportInitial();
}

final class ExportInProgress extends ExportState {
  const ExportInProgress();
}

final class ExportSuccess extends ExportState {
  const ExportSuccess({
    required this.filePath,
    required this.subject,
  });

  final String filePath;
  final String subject;

  @override
  List<Object?> get props => [filePath, subject];
}

final class ExportFailure extends ExportState {
  const ExportFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
