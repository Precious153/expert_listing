import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { unknown, online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityStatus.unknown) {
    _init();
  }

  void _init() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _checkInternetAccess(results);
    } catch (e) {
      emit(ConnectivityStatus.offline);
    }

    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      await _checkInternetAccess(results);
    });
  }

  Future<void> _checkInternetAccess(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.every((result) => result == ConnectivityResult.none)) {
      emit(ConnectivityStatus.offline);
      return;
    }

    // Connectivity exists, but does it have internet?
    try {
      final result = await InternetAddress.lookup('expertlisting-60hz.onrender.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        emit(ConnectivityStatus.online);
      } else {
        emit(ConnectivityStatus.offline);
      }
    } on SocketException catch (_) {
      emit(ConnectivityStatus.offline);
    } catch (_) {
      emit(ConnectivityStatus.offline);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
