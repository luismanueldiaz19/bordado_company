import '/src/datebase/url.dart';

//(id_depart,id_user,num_orden, ficha, name_logo, tipo_trabajo, cant_pieza, date_start)
String insertReportSastreria =
    "http://$ipLocal/settingmat/admin/insert/insert_report_sastreria.php";
//(id_depart,id_user,num_orden, ficha, name_logo, tipo_trabajo, cant_pieza, date_start)
String insertReportConfeccion =
    "http://$ipLocal/settingmat/admin/insert/insert_report_confeccion.php";

//'$date1' and '$date2'
String selectReportConfeccionDate =
    "http://$ipLocal/settingmat/admin/select/select_report_confeccion_date.php";

//'$date1' and '$date2'
String selectReportSastreriaDate =
    "http://$ipLocal/settingmat/admin/select/select_report_sastreria_date.php";

///------------------------------------------------////
/////date_start
String updateReportConfeccionStartDate =
    "http://$ipLocal/settingmat/admin/update/update_report_confeccion_start_date.php";

//date_end //
String updateReportConfeccionDateEnd =
    "http://$ipLocal/settingmat/admin/update/update_report_confeccion_date_end.php";

//date_end //
String updateReportSastreriaDateEnd =
    "http://$ipLocal/settingmat/admin/update/update_report_sastreria_date_end.php";

//  num_orden']; ['tipo_trabajo'];	['name_logo'];		['ficha'] ['id'];
String updateReportConfeccion =
    "http://$ipLocal/settingmat/admin/update/update_report_confeccion.php";

String updateReportSastreria =
    "http://$ipLocal/settingmat/admin/update/update_report_sastreria.php";

String updateReportConfeccionCantPieza =
    "http://$ipLocal/settingmat/admin/update/update_report_confeccion_cant_pieza.php";

String updateReportSastreriaCantPieza =
    "http://$ipLocal/settingmat/admin/update/update_report_sastreria_cant_pieza.php";

String deleteReportConfeccion =
    "http://$ipLocal/settingmat/admin/delete/delete_report_confeccion.php";

String deleteReportSastreria =
    "http://$ipLocal/settingmat/admin/delete/delete_report_sastreria.php";

String updateReportSastreriaComentario =
    "http://$ipLocal/settingmat/admin/update/update_report_sastreria_comentario.php";

String updateReportConfecionComentario =
    "http://$ipLocal/settingmat/admin/update/update_report_confeccion_comentario.php";

String updateSastreriaWorkComentario =
    "http://$ipLocal/settingmat/admin/update/update_sastreria_work_comentario.php";

String deleteSastreriaWorkCant =
    "http://$ipLocal/settingmat/admin/delete/delete_sastreria_work_cant.php";

String deleteSastreriaWork =
    "http://$ipLocal/settingmat/admin/delete/delete_sastreria_work.php";
