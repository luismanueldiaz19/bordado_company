import '/src/datebase/url.dart';

String insertPlanificacionLast =
    "http://$ipLocal/settingmat/admin/insert/insert_planificacion_last.php";
// insert_planificacion_last
String insertPlanificacionLastMigra =
    "http://$ipLocal/settingmat/admin/insert/insert_planificacion_last_migra.php";

///name_logo, num_orden, cant, ficha, fecha_planificado, fecha_start, fecha_entrega,name_depart,is_key_unique
String insertPlanificacion =
    "http://$ipLocal/settingmat/admin/insert/insert_planificacion.php";

// is_key_unique_product, tipo_product, cant, department,fecha_start,fecha_end
String insertProductoPlanificacionLast =
    "http://$ipLocal/settingmat/admin/insert/insert_producto_planificacion_last.php";

// is_key_unique_product, tipo_product, cant, department,fecha_start,fecha_end
String insertProductoPlanificacionLastMigration =
    "http://$ipLocal/settingmat/admin/insert/insert_producto_planificacion_last_migra.php";

String selectProductoPlanificacionLast =
    "http://$ipLocal/settingmat/admin/select/select_producto_planificacion_last.php";

String selectPlanificacionByMonthlyCreated =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_by_monthly_created.php";

///view
String selectPlanificacionLast =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_last_last.php";

String selectPlanificacionByMothEntregas =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_by_moth_entregas.php";

String selectPlanificacionLastValidarFicha =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_last_validar_ficha.php";

String selectProductoPlanificacionLastItemAll =
    "http://$ipLocal/settingmat/admin/select/select_producto_planificacion_last_item_all.php";

//date1  and date2 // modo ///
String selectProductoPlanificacionLastItemAllByDate =
    "http://$ipLocal/settingmat/admin/select/select_producto_planificacion_last_item_all_by_date.php";

String selectProductoPlanificacionLastIdKey =
    "http://$ipLocal/settingmat/admin/select/select_producto_planificacion_last_id_key.php";

// update_planificacion_last

String updatePlanificacionLast =
    "http://$ipLocal/settingmat/admin/update/update_planificacion_last.php";

String deleteProductoPlanificacionLast =
    "http://$ipLocal/settingmat/admin/delete/delete_producto_planificacion_last.php"; // este eliminar los item de una orden completa///

String deleteProductoPlanificacionLastRecord =
    "http://$ipLocal/settingmat/admin/delete/delete_producto_planificacion_last_record.php"; // este eliminar los item de una orden completa///

String deletePlanificacionLast =
    "http://$ipLocal/settingmat/admin/delete/delete_planificacion_last.php"; //// este eliminar orden completa y del historial

String updateProductoPlanificacionCommentLast =
    "http://$ipLocal/settingmat/admin/update/update_producto_planificacion_last_comment.php";

String updatePlanificacionCommentLast =
    "http://$ipLocal/settingmat/admin/update/update_planificacion_last_comment.php";

// update_producto_planificacion_last_calidad

String updateProductoPlanificacionLastCalidad =
    "http://$ipLocal/settingmat/admin/update/update_producto_planificacion_last_calidad.php";

// select_planificacion_last_record_by_date

String selectPlanificacionLastRecordByDate =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_last_record_by_date.php";

//select_report_entrada_salida_reception_by_date

String selectReportEntradaSalidaReceptionByDate =
    "http://$ipLocal/settingmat/admin/select/select_report_entrada_salida_reception_by_date.php";

//insert_report_entrada_salida_reception

String insertReportEntradaSalidaReception =
    "http://$ipLocal/settingmat/admin/insert/insert_report_entrada_salida_reception.php";

String selectPlanificacionLastRecordDeliveredByDate =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_last_record_date_delivered_by_date.php";

String selectPlanificacionLastRecordFechaStartByDate =
    "http://$ipLocal/settingmat/admin/select/select_planificacion_last_record_date_fecha_start_by_date.php";

String updateProductoPlanificacionLastIsWorking =
    "http://$ipLocal/settingmat/admin/update/update_producto_planificacion_last_is_working.php";

String updateProductoPlanificacionLastIsCalidad =
    "http://$ipLocal/settingmat/admin/update/update_producto_planificacion_last_is_calidad.php";

String selectProductoPlanificacionLastRecordByDate =
    "http://$ipLocal/settingmat/admin/select/select_producto_planificacion_last_record_by_date.php";

String updatePlanificacionLastStatu =
    "http://$ipLocal/settingmat/admin/update/update_planificacion_last_statu.php";

String updateProductoPlanificacionLastStatu =
    "http://$ipLocal/settingmat/admin/update/update_producto_planificacion_last_statu.php";
