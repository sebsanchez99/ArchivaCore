import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

part 'side_menu_state.freezed.dart';

//Estado del cubit del menú
@freezed
class SideMenuState with _$SideMenuState {
  const factory SideMenuState({
    //index que cambia las páginas
    @Default(0) int selectedIndex,
    //Atribito que cambia el estado del menú 
    @Default(SideMenuDisplayMode.auto) SideMenuDisplayMode displayMode
  }) = _SideMenuState;
}
