import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../core/constants/mock_data.dart';

final userProvider = StateNotifierProvider<UserNotifier, AppUser>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AppUser> {
  UserNotifier() : super(MockData.user);

  void updateUser(AppUser user) {
    state = user;
  }

  void addPoints(int points) {
    state = AppUser(
      id: state.id,
      prenom: state.prenom,
      nom: state.nom,
      localisation: state.localisation,
      roleActif: state.roleActif,
      rolesDisponibles: state.rolesDisponibles,
      points: state.points + points,
      kgValorises: state.kgValorises,
      moisActifs: state.moisActifs,
      dateInscription: state.dateInscription,
    );
  }
}
