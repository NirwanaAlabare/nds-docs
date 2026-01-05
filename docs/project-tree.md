---
title: Project Tree
---

Main folder tree overview. 

### app/ 
```
├── Console/
│   ├── Commands/
│   │   ├── MissMasterPlan.php
│   │   ├── MissReject.php
│   │   └── MissRework.php
│   └── Kernel.php
├── Events/
│   ├── CuttingChartUpdated.php
│   ├── CuttingChartUpdatedAll.php
│   ├── TestEvent.php
│   └── TriggerWipLine.php
├── Exceptions/
│   └── Handler.php
├── Exports/
│   ├── Cutting/
│   │   ├── CuttingOrderOutputExport.php
│   │   ├── CuttingPlanExport.php
│   │   ├── ExportCuttingForm.php
│   │   └── ExportCuttingFormReject.php
│   ├── DC/
│   │   ├── ExportDcIn.php
│   │   ├── ExportDcInDetail.php
│   │   ├── ExportLoadingLine - old.php
│   │   ├── ExportLoadingLine.php
│   │   ├── ExportSecondaryIn.php
│   │   ├── ExportSecondaryInDetail.php
│   │   ├── ExportSecondaryInHouse.php
│   │   └── ExportSecondaryInHouseDetail.php
│   ├── ExportDataPoUpload.php
│   ├── ExportDataTemplatePackingListHorizontal.php
│   ├── ExportDataTemplatePackingListVertical.php
│   ├── ExportDetailPemakaianKain.php
│   ├── ExportDetailReturSB.php
│   ├── ExportDetailStokOpname.php
│   ├── ExportLaporanBahanBakar.php
│   ├── ExportLaporanCeisaDetail.php
│   ├── ExportLaporanFGAlokasi.php
│   ├── ExportLaporanFGINList.php
│   ├── ExportLaporanFGINSummary.php
│   ├── ExportLaporanFGOUTList.php
│   ├── ExportLaporanFGOUTSummary.php
│   ├── ExportLaporanFGReturList.php
│   ├── ExportLaporanFGReturSummary.php
│   ├── ExportLaporanFGStokMutasi.php
│   ├── ExportLaporanFGStokMutasiInternal.php
│   ├── ExportLaporanLoading.php
│   ├── ExportLaporanMutasiKaryawan.php
│   ├── ExportLaporanMutasiMesin.php
│   ├── ExportLaporanMutasiMesinMaster.php
│   ├── ExportLaporanMutasiMesinStok.php
│   ├── ExportLaporanMutasiMesinStokDetail.php
│   ├── ExportLaporanMutBarcode.php
│   ├── ExportLaporanMutDetail.php
│   ├── ExportLaporanMutGlobal.php
│   ├── ExportLaporanPackingIn.php
│   ├── ExportLaporanPackingMasterKarton.php
│   ├── ExportLaporanPackingNeedleCheck.php
│   ├── ExportLaporanPackingOut.php
│   ├── ExportLaporanPemasukan.php
│   ├── ExportLaporanPemasukanRoll.php
│   ├── ExportLaporanPenerimaanFGStokBPB.php
│   ├── ExportLaporanPengeluaran.php
│   ├── ExportLaporanPengeluaranFGStokBPPB.php
│   ├── ExportLaporanPengeluaranRoll.php
│   ├── ExportLaporanPPICTracking.php
│   ├── ExportLaporanQcpass.php
│   ├── ExportLaporanRekonsiliasi.php
│   ├── ExportLaporanRoll.php
│   ├── ExportLaporanStokOpname.php
│   ├── ExportLaporanStokOpnameDetail.php
│   ├── ExportLaporanStokOpnameDetailBarcode.php
│   ├── ExportLaporanTrfGarment.php
│   ├── ExportPemakaianKain.php
│   ├── ExportPPIC_Master_so_ppic.php
│   ├── ExportPPIC_Master_so_sb.php
│   ├── ExportReportCutting.php
│   ├── ExportReportCuttingDaily.php
│   ├── ExportReportCuttingData.php
│   ├── ExportReportCuttingSinglePage.php
│   ├── ExportTrackStocker.php
│   ├── ExportTrackWorksheet.php
│   ├── export_excel_laporan_daily_cost.php
│   ├── export_excel_laporan_daily_earn_buyer.php
│   ├── export_excel_laporan_earning.php
│   ├── export_excel_laporan_profit_line.php
│   ├── export_excel_laporan_sum_buyer.php
│   ├── export_excel_laporan_sum_full_earn.php
│   ├── export_excel_laporan_sum_prod_earn.php
│   ├── export_excel_packing_list.php
│   ├── export_excel_qc_inspect_lot.php
│   ├── export_excel_qc_inspect_roll.php
│   ├── Export_excel_rep_packing_line_sum_buyer.php
│   ├── Export_excel_rep_packing_line_sum_range.php
│   ├── Export_excel_rep_packing_mutasi.php
│   ├── NoDataExport.php
│   ├── Packing/
│   │   └── PackingOutputExport.php
│   ├── ProductionAllExport.php
│   ├── ProductionDefectExport.php
│   ├── ProductionExport.php
│   ├── Report_eff_new_export.php
│   ├── Sewing/
│   │   ├── CheckOutputDetailListExport.php
│   │   ├── CheckOutputDetailListExportOld.php
│   │   ├── ChiefSewingRangeExport.php
│   │   ├── DefectInOutExport.php
│   │   ├── DefectInOutFinishingExport.php
│   │   ├── DefectRateExport.php
│   │   ├── ExportReportDetailOutputData.php
│   │   ├── ExportReportDetailOutputDataPacking.php
│   │   ├── ExportReportEfficiency.php
│   │   ├── ExportReportEfficiencyData.php
│   │   ├── ExportReportEfficiencySingle.php
│   │   ├── ExportReportEfficiencySingle1.php
│   │   ├── ExportReportOutput.php
│   │   ├── ExportReportOutputData.php
│   │   ├── ExportReportProduction.php
│   │   ├── ExportReportProductionData.php
│   │   ├── LeaderSewingRangeExport.php
│   │   ├── LineWipExport.php
│   │   ├── MasterLineExport.php
│   │   ├── OrderOutputExport.php
│   │   ├── OutputExport.php
│   │   ├── OutputExportCustomRange.php
│   │   ├── ReportDefectExport.php
│   │   ├── ReportHourlyExport.php
│   │   ├── ReportHourlyExportMonthly.php
│   │   ├── ReportRejectExport.php
│   │   ├── TopDefectExport.php
│   │   └── TopRejectExport.php
│   └── Stocker/
│       ├── StockerListDetailExport.php
│       └── StockerListExport.php
├── helpers.php
├── Http/
│   ├── Controllers/
│   │   ├── AccountingController.php
│   │   ├── Auth/
│   │   │   ├── ConfirmPasswordController.php
│   │   │   ├── ForgotPasswordController.php
│   │   │   ├── LoginController.php
│   │   │   ├── RegisterController.php
│   │   │   ├── ResetPasswordController.php
│   │   │   └── VerificationController.php
│   │   ├── Backup/
│   │   │   └── DCInController_backup.php
│   │   ├── BarcodePackingController.php
│   │   ├── Controller.php
│   │   ├── Cutting/
│   │   │   ├── CompletedFormController.php
│   │   │   ├── CuttingFormController.php
│   │   │   ├── CuttingFormManualController.php
│   │   │   ├── CuttingFormPieceController.php
│   │   │   ├── CuttingFormPilotController.php
│   │   │   ├── CuttingFormRejectController.php
│   │   │   ├── CuttingPlanController.php
│   │   │   ├── CuttingToolsController.php
│   │   │   ├── MasterPipingController.php
│   │   │   ├── PipingController.php
│   │   │   ├── PipingLoadingController.php
│   │   │   ├── PipingProcessController.php
│   │   │   ├── PipingStockController.php
│   │   │   ├── ReportCuttingController.php
│   │   │   ├── RollController.php
│   │   │   └── SpreadingController.php
│   │   ├── DashboardFabricController.php
│   │   ├── DashboardWipLineController.php
│   │   ├── DC/
│   │   │   ├── BonLoadingController.php
│   │   │   ├── DCInController.php
│   │   │   ├── DcToolsController.php
│   │   │   ├── LoadingLineController.php
│   │   │   ├── LoadingOutController.php
│   │   │   ├── RackController.php
│   │   │   ├── RackStockerController.php
│   │   │   ├── SecondaryInController.php
│   │   │   ├── SecondaryInhouseController.php
│   │   │   ├── StockDcCompleteController.php
│   │   │   ├── StockDcIncompleteController.php
│   │   │   ├── StockDcWipController.php
│   │   │   ├── TrolleyController.php
│   │   │   └── TrolleyStockerController.php
│   │   ├── EmployeeController.php
│   │   ├── FGStokBPBController.php
│   │   ├── FGStokBPPBController.php
│   │   ├── FGStokLaporanController.php
│   │   ├── FGStokMasterController.php
│   │   ├── FGStokMutasiController.php
│   │   ├── FinishGoodAlokasiKartonController.php
│   │   ├── FinishGoodDashboardController.php
│   │   ├── FinishGoodMasterLokasiController.php
│   │   ├── FinishGoodPenerimaanController.php
│   │   ├── FinishGoodPengeluaranController.php
│   │   ├── FinishGoodReturController.php
│   │   ├── GAApprovalBahanBakarController.php
│   │   ├── GAPengajuanBahanBakarController.php
│   │   ├── General/
│   │   │   ├── DashboardController.php
│   │   │   ├── GeneralController.php
│   │   │   ├── HomeController.php
│   │   │   ├── SummaryController.php
│   │   │   ├── TrackController.php
│   │   │   └── WorksheetController.php
│   │   ├── IEDashboardController.php
│   │   ├── IEMasterPartProcessController.php
│   │   ├── IEMasterProcessController.php
│   │   ├── IE_Laporan_Controller.php
│   │   ├── IE_Proses_OB_Controller.php
│   │   ├── InMaterialController.php
│   │   ├── KonfPemasukanController.php
│   │   ├── KonfPengeluaranController.php
│   │   ├── LapDetPemasukanController.php
│   │   ├── LapDetPemasukanRollController.php
│   │   ├── LapDetPengeluaranController.php
│   │   ├── LapDetPengeluaranRollController.php
│   │   ├── LapMutasiBarcodeController.php
│   │   ├── LapMutasiDetailController.php
│   │   ├── LapMutasiGlobalController.php
│   │   ├── MaintainBpbController.php
│   │   ├── Marker/
│   │   │   └── MarkerController.php
│   │   ├── MarketingDashboardController.php
│   │   ├── Marketing_CostingController.php
│   │   ├── MasterLokasiController.php
│   │   ├── MgtReportDailyCostController.php
│   │   ├── MgtReportDailyEarnBuyerController.php
│   │   ├── MgtReportDashboardController.php
│   │   ├── MgtReportEarningController.php
│   │   ├── MgtReportProfitLineController.php
│   │   ├── MgtReportProsesController.php
│   │   ├── MgtReportSumBuyerController.php
│   │   ├── MgtReportSumFullEarnController.php
│   │   ├── MgtReportSumProdEarnController.php
│   │   ├── MutasiMesinController.php
│   │   ├── MutasiMesinLaporanController.php
│   │   ├── MutasiMesinMasterController.php
│   │   ├── MutasiMesinStockOpnameController.php
│   │   ├── MutLokasiController.php
│   │   ├── OutMaterialController.php
│   │   ├── PackingDashboardController.php
│   │   ├── PackingLineController.php
│   │   ├── PackingMasterKartonController.php
│   │   ├── PackingNeedleCheckController.php
│   │   ├── PackingPackingInController.php
│   │   ├── PackingPackingListController.php
│   │   ├── PackingPackingOutController.php
│   │   ├── PackingReportController.php
│   │   ├── PackingTransferGarmentController.php
│   │   ├── Part/
│   │   │   ├── MasterPartController.php
│   │   │   ├── MasterSecondaryController.php
│   │   │   └── PartController.php
│   │   ├── PPICDashboardController.php
│   │   ├── PPIC_LaporanTrackingController.php
│   │   ├── PPIC_MasterSOController.php
│   │   ├── PPIC_MonitoringMaterialController.php
│   │   ├── PPIC_MonitoringMaterialDetController.php
│   │   ├── PPIC_MonitoringMaterialSumController.php
│   │   ├── PPIC_tools_adjustmentController.php
│   │   ├── ProcurementController.php
│   │   ├── Qc/
│   │   │   ├── QcInspectDetailController.php
│   │   │   └── QcInspectHeaderController.php
│   │   ├── QCInspectDashboardController.php
│   │   ├── QCInspectLaporanController.php
│   │   ├── QCInspectMasterController.php
│   │   ├── QCInspectPrintBintexShadeBandController.php
│   │   ├── QCInspectProsesFabricRelaxationController.php
│   │   ├── QCInspectProsesFormInspectController.php
│   │   ├── QCInspectProsesPackingListController.php
│   │   ├── QCInspectShadeBandController.php
│   │   ├── QcPassController.php
│   │   ├── ReportDocController.php
│   │   ├── ReportHourlyController.php
│   │   ├── ReqMaterialController.php
│   │   ├── ReturInMaterialController.php
│   │   ├── ReturMaterialController.php
│   │   ├── ReviseQRController.php
│   │   ├── SampleController.php
│   │   ├── Sewing/
│   │   │   ├── ChiefSewingRangeExport.php
│   │   │   ├── DataDetailProduksiController.php
│   │   │   ├── DataDetailProduksiDayController.php
│   │   │   ├── DataProduksiController.php
│   │   │   ├── LineDashboardController.php
│   │   │   ├── LineWipController.php
│   │   │   ├── MasterBuyerController.php
│   │   │   ├── MasterDefectController.php
│   │   │   ├── MasterJabatanController.php
│   │   │   ├── MasterKaryawanController.php
│   │   │   ├── MasterKursBiController.php
│   │   │   ├── MasterLineController.php
│   │   │   ├── MasterPlanController.php
│   │   │   ├── OrderDefectController.php
│   │   │   ├── ReportController.php
│   │   │   ├── ReportDefectController.php
│   │   │   ├── ReportDetailOutputController.php
│   │   │   ├── ReportEfficiencyController.php
│   │   │   ├── ReportEfficiencyNewController.php
│   │   │   ├── ReportMutasiOutputController.php
│   │   │   ├── ReportOutputController.php
│   │   │   ├── ReportProductionController.php
│   │   │   ├── ReportRejectController.php
│   │   │   ├── SewingInputOutput.php
│   │   │   ├── SewingToolsController.php
│   │   │   ├── TrackOrderOutputController.php
│   │   │   ├── TransferOutputController.php
│   │   │   └── UndoOutputController.php
│   │   ├── Stocker/
│   │   │   ├── StockerController.php
│   │   │   └── StockerToolsController.php
│   │   ├── StockOpnameController.php
│   │   ├── TransferBpbController.php
│   │   ├── User/
│   │   │   ├── ManageAccessController.php
│   │   │   ├── ManageRoleController.php
│   │   │   ├── ManageUserController.php
│   │   │   ├── ManageUserLineController.php
│   │   │   └── UserController.php
│   │   └── WarehouseController.php
│   ├── Kernel.php
│   ├── Livewire/
│   │   ├── Cutting/
│   │   │   └── TrackCuttingOutput.php
│   │   ├── Packing/
│   │   │   └── TrackPackingOutput.php
│   │   ├── Qc/
│   │   │   ├── Inspect/
│   │   │   │   └── QCInmaterialFabricController.php
│   │   │   └── Master/
│   │   │       ├── Defect.php
│   │   │       ├── GroupInspect.php
│   │   │       ├── Lenght.php
│   │   │       ├── Result.php
│   │   │       └── Satuan.php
│   │   └── Sewing/
│   │       ├── LineDashboardList.php
│   │       ├── LineMasterplan.php
│   │       ├── ReportDefectInOut.php
│   │       ├── ReportLineUser.php
│   │       ├── ReportOutput.php
│   │       ├── ReportProduction.php
│   │       ├── TrackOrderOutput.php
│   │       └── TransferOutput.php
│   ├── Middleware/
│   │   ├── Authenticate.php
│   │   ├── EncryptCookies.php
│   │   ├── IsAdmin.php
│   │   ├── IsBC.php
│   │   ├── IsDc.php
│   │   ├── IsFGStock.php
│   │   ├── IsFinishGood.php
│   │   ├── IsGa.php
│   │   ├── IsHr.php
│   │   ├── IsManager.php
│   │   ├── IsMarker.php
│   │   ├── IsMarketing.php
│   │   ├── IsMaster.php
│   │   ├── IsMaterial.php
│   │   ├── IsMeja.php
│   │   ├── IsPacking.php
│   │   ├── IsPpic.php
│   │   ├── IsQcpass.php
│   │   ├── IsReqMaterial.php
│   │   ├── IsSample.php
│   │   ├── IsSewing.php
│   │   ├── IsSpreading.php
│   │   ├── IsStocker.php
│   │   ├── IsStockOpname.php
│   │   ├── IsWarehouse.php
│   │   ├── PreventRequestsDuringMaintenance.php
│   │   ├── RedirectIfAuthenticated.php
│   │   ├── RoleMiddleware.php
│   │   ├── TrimStrings.php
│   │   ├── TrustHosts.php
│   │   ├── TrustProxies.php
│   │   └── VerifyCsrfToken.php
│   └── Requests/
│       ├── StoreMasterPipingRequest.php
│       ├── StoreUserRequest.php
│       ├── UpdateUserDetailRequest.php
│       └── UpdateUserRequest.php
├── Imports/
│   ├── ImportDailyCost.php
│   ├── ImportIE_MasterProcess.php
│   ├── ImportLokasiMaterial.php
│   ├── ImportMasterLine.php
│   ├── ImportMasterPlan.php
│   ├── ImportPPIC_SO.php
│   ├── ImportStockerManual.php
│   ├── UploadPackingListHeader.php
│   ├── UploadPackingListKarton.php
│   ├── UploadPackingListKartonVertical.php
│   ├── UploadPPICAdjOutput.php
│   └── UploadQtyKarton.php
├── Models/
│   ├── AbsenKaryawan.php
│   ├── Auth/
│   │   ├── Access.php
│   │   ├── Role.php
│   │   ├── RoleAccess.php
│   │   ├── User.php
│   │   └── UserRole.php
│   ├── Bpb.php
│   ├── BpbSB.php
│   ├── BppbDet.php
│   ├── BppbDetTemp.php
│   ├── BppbHeader.php
│   ├── BppbReq.php
│   ├── BppbRO.php
│   ├── BppbSB.php
│   ├── Cutting/
│   │   ├── CutPlan.php
│   │   ├── CutPlanOutput.php
│   │   ├── CutPlanOutputForm.php
│   │   ├── FormCutInput.php
│   │   ├── FormCutInputDetail.php
│   │   ├── FormCutInputDetailLap.php
│   │   ├── FormCutInputDetailSambungan.php
│   │   ├── FormCutInputLostTime.php
│   │   ├── FormCutPiece.php
│   │   ├── FormCutPieceDetail.php
│   │   ├── FormCutPieceDetailSize.php
│   │   ├── FormCutReject.php
│   │   ├── FormCutRejectDetail.php
│   │   ├── ManualFormCut.php
│   │   ├── ManualFormCutDetail.php
│   │   ├── ManualFormCutDetailLap.php
│   │   ├── ManualFormCutLostTime.php
│   │   ├── ManualFormCutMarker.php
│   │   ├── ManualFormCutRatio.php
│   │   ├── MasterPiping.php
│   │   ├── Piping.php
│   │   ├── PipingLoading.php
│   │   ├── PipingProcess.php
│   │   ├── PipingProcessDetail.php
│   │   └── ScannedItem.php
│   ├── Daily_cost_tmp.php
│   ├── Dc/
│   │   ├── DCIn.php
│   │   ├── DCIn_backup.php
│   │   ├── LoadingLine.php
│   │   ├── LoadingLineHistory.php
│   │   ├── LoadingLinePlan.php
│   │   ├── Rack.php
│   │   ├── RackDetail.php
│   │   ├── RackDetailStocker.php
│   │   ├── SecondaryIn.php
│   │   ├── SecondaryInhouse.php
│   │   ├── Trolley.php
│   │   └── TrolleyStocker.php
│   ├── DefectTemp.php
│   ├── Employee.php
│   ├── FGStokbppb.php
│   ├── Hris/
│   │   └── MasterEmployee.php
│   ├── InMaterial.php
│   ├── InMaterialFabric.php
│   ├── InMaterialFabricDet.php
│   ├── InMaterialLokasi.php
│   ├── InMaterialLokasiTemp.php
│   ├── InMaterialLokTemp.php
│   ├── IrLogTrans.php
│   ├── IrTransBpb.php
│   ├── Journal.php
│   ├── Marker/
│   │   ├── Marker.php
│   │   └── MarkerDetail.php
│   ├── MasterLokasi.php
│   ├── MasterSbWs.php
│   ├── MutasiDetailTemp.php
│   ├── MutasiDetailTempCancel.php
│   ├── MutKaryawan.php
│   ├── MutLokasi.php
│   ├── MutLokasiHeader.php
│   ├── MutMesin.php
│   ├── OutputPackingNds.php
│   ├── Packing_list_upload_header.php
│   ├── Packing_list_upload_karton.php
│   ├── Packing_list_upload_karton_vertical.php
│   ├── Packing_master_carton_upload_qty.php
│   ├── Part/
│   │   ├── MasterPart.php
│   │   ├── MasterSecondary.php
│   │   ├── MasterTujuan.php
│   │   ├── Part.php
│   │   ├── PartDetail.php
│   │   ├── PartDetailItem.php
│   │   └── PartForm.php
│   ├── PPICMasterSo.php
│   ├── PPIC_master_so_tmp.php
│   ├── qc/
│   │   ├── inspect/
│   │   │   ├── InmaterialLokasi.php
│   │   │   ├── QcInspectDetail.php
│   │   │   └── QcInspectHeader.php
│   │   ├── MasterDefect.php
│   │   ├── MasterGroupInspect.php
│   │   ├── MasterLenght.php
│   │   ├── MasterResult.php
│   │   └── MasterSatuan.php
│   ├── QcDefectDef.php
│   ├── QcDefectTemp.php
│   ├── QcInspect.php
│   ├── QcInspectDet.php
│   ├── QcInspectSum.php
│   ├── QcInspectTemp.php
│   ├── report_output_adj_tmp.php
│   ├── SaldoAwalFabric.php
│   ├── Sample.php
│   ├── SignalBit/
│   │   ├── ActCosting.php
│   │   ├── BomJoItem.php
│   │   ├── Defect.php
│   │   ├── DefectArea.php
│   │   ├── DefectFinish.php
│   │   ├── DefectInOut.php
│   │   ├── DefectPacking.php
│   │   ├── DefectType.php
│   │   ├── EmployeeLine.php
│   │   ├── EmployeeLineTmp.php
│   │   ├── EmployeeProduction.php
│   │   ├── MasterPlan.php
│   │   ├── OutputFinishing.php
│   │   ├── OutputGudangStok.php
│   │   ├── OutputPackingPo.php
│   │   ├── ProductType.php
│   │   ├── Reject.php
│   │   ├── RejectIn.php
│   │   ├── RejectInDetail.php
│   │   ├── RejectInDetailPosition.php
│   │   ├── RejectOut.php
│   │   ├── RejectOutDetail.php
│   │   ├── RejectPacking.php
│   │   ├── Rework.php
│   │   ├── ReworkPacking.php
│   │   ├── Rft.php
│   │   ├── RftPacking.php
│   │   ├── RftPackingPo.php
│   │   ├── So.php
│   │   ├── SoDet.php
│   │   ├── Undo.php
│   │   ├── UndoPacking.php
│   │   ├── UndoPackingPo.php
│   │   ├── UserDefect.php
│   │   ├── UserLine.php
│   │   └── UserSbWip.php
│   ├── SoCopySaldo.php
│   ├── SoDetail.php
│   ├── SoDetailTemp.php
│   ├── SoDetailTempCancel.php
│   ├── SoHeader.php
│   ├── SoLogCopySaldo.php
│   ├── Stocker/
│   │   ├── ModifySizeQty.php
│   │   ├── MonthCount.php
│   │   ├── Stocker.php
│   │   ├── StockerAdditional.php
│   │   ├── StockerAdditionalDetail.php
│   │   ├── StockerDetail.php
│   │   ├── StockerSeparate.php
│   │   ├── StockerSeparateDetail.php
│   │   └── YearSequence.php
│   ├── Summary/
│   │   ├── DataDetailProduksi.php
│   │   ├── DataDetailProduksiDay.php
│   │   ├── DataProduksi.php
│   │   ├── KaryawanHRIS.php
│   │   ├── MasterBuyer.php
│   │   ├── MasterJabatan.php
│   │   ├── MasterKaryawan.php
│   │   ├── MasterKursBi.php
│   │   ├── MasterKursBiSB.php
│   │   ├── MasterPlanSB.php
│   │   └── MasterSupplierSB.php
│   ├── Tempbpb.php
│   ├── TemporaryBomItem.php
│   ├── TemporaryPanel.php
│   ├── Tmp_Dc_In_backup.php
│   ├── Traits/
│   │   └── HasUuid.php
│   ├── UnitLokasi.php
│   └── WorksheetProduction.php
├── Observers/
│   ├── CuttingFormDetailLapObserver.php
│   ├── CuttingFormDetailObserver.php
│   └── CuttingFormObserver.php
├── Providers/
│   ├── AppServiceProvider.php
│   ├── AuthServiceProvider.php
│   ├── BroadcastServiceProvider.php
│   ├── EventServiceProvider.php
│   └── RouteServiceProvider.php
├── Scopes/
│   ├── InactiveStocker.php
│   ├── ThisYearScope.php
│   └── ThisYearScopeDetail.php
└── Services/
    ├── CuttingService.php
    ├── GeneralService.php
    ├── SewingService.php
    └── StockerService.php
```

### config/
```
├── app.php
├── auth.php
├── broadcasting.php
├── cache.php
├── cors.php
├── database.php
├── datatables.php
├── debugbar.php
├── dompdf.php
├── excel.php
├── filesystems.php
├── hashing.php
├── livewire.php
├── logging.php
├── mail.php
├── queue.php
├── redis.php
├── services.php
├── session.php
└── view.php
``` 

### public/
```
├── assets/
│   ├── example/
│   │   ├── contoh-import-master-line.xlsx
│   │   ├── contoh-import-master-plan.xlsx
│   │   └── contoh-import-stocker-manual.xlsx
│   ├── fonts/...
│   ├── plugins/...
│   └── dist/...
│       ├── css/
│       ├── adminlte.css
│       ├── adminlte.css.map
│       ├── adminlte.min.css
│       ├── adminlte.min.css.map
│       ├── alt/
│       │   ├── adminlte.components.css
│       │   ├── adminlte.components.css.map
│       │   ├── adminlte.components.min.css
│       │   ├── adminlte.components.min.css.map
│       │   ├── adminlte.core.css
│       │   ├── adminlte.core.css.map
│       │   ├── adminlte.core.min.css
│       │   ├── adminlte.core.min.css.map
│       │   ├── adminlte.extra-components.css
│       │   ├── adminlte.extra-components.css.map
│       │   ├── adminlte.extra-components.min.css
│       │   ├── adminlte.extra-components.min.css.map
│       │   ├── adminlte.light.css
│       │   ├── adminlte.light.css.map
│       │   ├── adminlte.light.min.css
│       │   ├── adminlte.light.min.css.map
│       │   ├── adminlte.pages.css
│       │   ├── adminlte.pages.css.map
│       │   ├── adminlte.pages.min.css
│       │   ├── adminlte.pages.min.css.map
│       │   ├── adminlte.plugins.css
│       │   ├── adminlte.plugins.css.map
│       │   ├── adminlte.plugins.min.css
│       │   └── adminlte.plugins.min.css.map
│       ├── font.css
│       ├── style.css
│       └── style.scss
|       ├── img/
│       ├── accounting_img.png
│       ├── boxed-bg.jpg
│       ├── boxed-bg.png
│       ├── credit/
│       │   ├── american-express.png
│       │   ├── cirrus.png
│       │   ├── mastercard.png
│       │   ├── paypal.png
│       │   ├── paypal2.png
│       │   └── visa.png
│       ├── cutting.png
│       ├── default-150x150.png
│       ├── distribution.jpeg
│       ├── doc_report.png
│       ├── finish_good.png
│       ├── general_affair.png
│       ├── gold-medal.png
│       ├── icon/
│       │   ├── checked.png
│       │   └── target.png
│       ├── icons.png
│       ├── IE.png
│       ├── inspect.png
│       ├── logo-icon-old-1.png
│       ├── logo-icon-old.png
│       ├── logo-icon.png
│       ├── logo-nds4-old.png
│       ├── logo-nds4.png
│       ├── manage-users.png
│       ├── management_report.png
│       ├── marker.png
│       ├── marketing.png
│       ├── marketing_.png
│       ├── mut_karyawan.jpg
│       ├── mut_mesin.png
│       ├── nag-logo.png
│       ├── packing.png
│       ├── person.png
│       ├── photo1.png
│       ├── photo2.png
│       ├── photo3.jpg
│       ├── photo4.jpg
│       ├── ppic.png
│       ├── procurement.png
│       ├── prod-1.jpg
│       ├── prod-2.jpg
│       ├── prod-3.jpg
│       ├── prod-4.jpg
│       ├── prod-5.jpg
│       ├── qr-generate.png
│       ├── result.png
│       ├── sample.png
│       ├── scan-qr.png
│       ├── sewingline.png
│       ├── signout.png
│       ├── stocker.png
│       ├── stock_opname.png
│       ├── tabicon-old.png
│       ├── tabicon-old1.png
│       ├── tabicon.png
│       ├── tools.png
│       ├── track.png
│       ├── warehouse.png
│       ├── whs_accs.png
│       ├── whs_fabric.png
│       ├── whs_fg_stock.png
│       ├── work-progress.png
│       └── worksheet.png
│       └── js/
│           ├── adminlte.js
│           ├── adminlte.js.map
│           ├── adminlte.min.js
│           ├── adminlte.min.js.map
│           ├── demo.js
│           ├── pages/
│           │   ├── dashboard.js
│           │   ├── dashboard2.js
│           │   └── dashboard3.js
│           └── script.js
├── js/
│   ├── app.js
│   ├── app.js.LICENSE.txt
│   ├── app.js.map
│   ├── laravel-echo-setup.js
│   └── laravel-echo-setup.js.map
├── css/
│   ├── app.css
│   └── app.css.map
├── favicon.ico
├── file_upload/...
├── robots.txt
├── storage/...
├── tasks/
│   └── log.txt
└── web.config
```

### resources/
```
├── css/
│   └── app.css
├── js/
│   ├── app.js
│   ├── bootstrap.js
│   └── laravel-echo-setup.js
├── lang/
│   └── en/
│       ├── auth.php
│       ├── pagination.php
│       ├── passwords.php
│       └── validation.php
├── sass/
│   ├── app.scss
│   └── _variables.scss
└── views/
    ├── access/
    │   └── access.blade.php
    ├── accounting/
    │   ├── create-update-ceisa.blade.php
    │   ├── export-ceisa-detail.blade.php
    │   ├── export.blade.php
    │   ├── homepage.blade.php
    │   ├── laporan-ceisa-detail.blade.php
    │   ├── laporan-rekonsiliasi.blade.php
    │   ├── pdf/
    │   │   └── print-qr.blade.php
    │   └── update-ceisa.blade.php
    ├── auth/
    │   ├── login.blade.php
    │   ├── passwords/
    │   │   ├── confirm.blade.php
    │   │   ├── email.blade.php
    │   │   └── reset.blade.php
    │   ├── register.blade.php
    │   └── verify.blade.php
    ├── bon-mutasi.blade.php
    ├── component/
    │   ├── calendar.blade.php
    │   ├── charts/
    │   │   ├── chartjs.html
    │   │   ├── flot.html
    │   │   ├── inline.html
    │   │   └── uplot.html
    │   ├── examples/
    │   │   ├── 404.html
    │   │   ├── 500.html
    │   │   ├── blank.html
    │   │   ├── contact-us.html
    │   │   ├── contacts.html
    │   │   ├── e-commerce.html
    │   │   ├── faq.html
    │   │   ├── forgot-password-v2.html
    │   │   ├── forgot-password.html
    │   │   ├── invoice-print.html
    │   │   ├── invoice.html
    │   │   ├── language-menu.html
    │   │   ├── legacy-user-menu.html
    │   │   ├── lockscreen.html
    │   │   ├── login-v2.html
    │   │   ├── login.html
    │   │   ├── pace.html
    │   │   ├── profile.html
    │   │   ├── project-add.html
    │   │   ├── project-detail.html
    │   │   ├── project-edit.html
    │   │   ├── projects.html
    │   │   ├── recover-password-v2.html
    │   │   ├── recover-password.html
    │   │   ├── register-v2.html
    │   │   └── register.html
    │   ├── forms/
    │   │   ├── advanced.blade.php
    │   │   ├── editors.blade.php
    │   │   ├── general.blade.php
    │   │   └── validation.blade.php
    │   ├── gallery.blade.php
    │   ├── kanban.blade.php
    │   ├── layouts/
    │   │   ├── index.blade.php
    │   │   ├── link.blade.php
    │   │   ├── navbar.blade.php
    │   │   ├── script.blade.php
    │   │   └── sidebar.blade.php
    │   ├── mailbox/
    │   │   ├── compose.html
    │   │   ├── mailbox.html
    │   │   └── read-mail.html
    │   ├── search/
    │   │   ├── enhanced-results.html
    │   │   ├── enhanced.html
    │   │   ├── simple-results.html
    │   │   └── simple.html
    │   ├── tables/
    │   │   ├── data.blade.php
    │   │   ├── jsgrid.blade.php
    │   │   └── simple.blade.php
    │   ├── UI/
    │   │   ├── buttons.blade.php
    │   │   ├── general.blade.php
    │   │   ├── icons.blade.php
    │   │   ├── modals.blade.php
    │   │   ├── ribbons.blade.php
    │   │   ├── sliders.blade.php
    │   │   └── timeline.blade.php
    │   └── widgets.blade.php
    ├── custom.blade.php
    ├── cutting/
    │   ├── chart/
    │   │   ├── dashboard-chart-detail.blade.php
    │   │   ├── dashboard-chart-list.blade.php
    │   │   └── dashboard-chart.blade.php
    │   ├── completed-form/
    │   │   ├── completed-form-detail.blade.php
    │   │   └── completed-form.blade.php
    │   ├── cutting-form/
    │   │   ├── cutting-form-process.blade.php
    │   │   └── cutting-form.blade.php
    │   ├── cutting-form-manual/
    │   │   ├── create-cutting-form-manual.blade.php
    │   │   ├── cutting-form-manual-process.blade.php
    │   │   └── cutting-form-manual.blade.php
    │   ├── cutting-form-piece/
    │   │   ├── create-cutting-form-piece.blade.php
    │   │   └── cutting-form-piece.blade.php
    │   ├── cutting-form-pilot/
    │   │   ├── create-cutting-form-pilot.blade.php
    │   │   ├── cutting-form-pilot-process.blade.php
    │   │   └── cutting-form-pilot.blade.php
    │   ├── cutting-form-reject/
    │   │   ├── create-cutting-form-reject.blade.php
    │   │   ├── cutting-form-reject.blade.php
    │   │   ├── edit-cutting-form-reject.blade.php
    │   │   ├── export/
    │   │   │   └── cutting-form-reject.blade.php
    │   │   ├── show-cutting-form-reject.blade.php
    │   │   ├── stock-cutting-reject-old.blade.php
    │   │   └── stock-cutting-reject.blade.php
    │   ├── cutting-plan/
    │   │   ├── create-cutting-plan-output.blade.php
    │   │   ├── create-cutting-plan.blade.php
    │   │   ├── cutting-plan-output.blade.php
    │   │   ├── cutting-plan.blade.php
    │   │   ├── detail-cutting-plan-output.blade.php
    │   │   └── export/
    │   │       └── cutting-plan-export.blade.php
    │   ├── dashboard.blade.php
    │   ├── export/
    │   │   └── cutting-order-output-export.blade.php
    │   ├── master-piping/
    │   │   ├── create-master-piping.blade.php
    │   │   └── master-piping.blade.php
    │   ├── piping/
    │   │   ├── create-piping.blade.php
    │   │   ├── edit-piping.blade.php
    │   │   └── piping.blade.php
    │   ├── piping-loading/
    │   │   ├── create-piping-loading.blade.php
    │   │   └── piping-loading.blade.php
    │   ├── piping-process/
    │   │   ├── create-piping-process.blade.php
    │   │   ├── pdf/
    │   │   │   └── pdf-piping-process.blade.php
    │   │   └── piping-process.blade.php
    │   ├── piping-stock/
    │   │   ├── piping-stock.blade.php
    │   │   └── show-piping-stock.blade.php
    │   ├── report/
    │   │   ├── export/
    │   │   │   ├── detail-pemakaian-roll.blade.php
    │   │   │   ├── pemakaian-roll.blade.php
    │   │   │   ├── report-cutting-daily.blade.php
    │   │   │   └── report-cutting.blade.php
    │   │   ├── pemakaian-roll.blade.php
    │   │   ├── report-cutting-output-daily.blade.php
    │   │   ├── report-cutting.blade.php
    │   │   └── track-cutting-output.blade.php
    │   ├── roll/
    │   │   ├── export/
    │   │   │   └── roll.blade.php
    │   │   ├── pdf/
    │   │   │   ├── mass-sisa-kain-roll.blade.php
    │   │   │   └── sisa-kain-roll.blade.php
    │   │   ├── roll.blade.php
    │   │   └── sisa-kain-roll.blade.php
    │   ├── spreading/
    │   │   ├── create-spreading.blade.php
    │   │   ├── export/
    │   │   │   └── cutting-form.blade.php
    │   │   └── spreading.blade.php
    │   └── tools/
    │       └── tools.blade.php
    ├── dashboard-fabric.blade.php
    ├── dashboard-mesin.blade.php
    ├── dashboard.blade.php
    ├── dc/
    │   ├── dashboard.blade.php
    │   ├── dc-in/
    │   │   ├── backucup/
    │   │   │   ├── create-dc-in.blade_backup.php
    │   │   │   └── dc-in.blade_backup.php
    │   │   ├── create-dc-in.blade.php
    │   │   ├── dc-in.blade.php
    │   │   └── export/
    │   │       ├── dc-in-detail-excel.blade.php
    │   │       └── dc-in-excel.blade.php
    │   ├── loading-line/
    │   │   ├── bon-loading.blade.php
    │   │   ├── create-loading-plan.blade.php
    │   │   ├── detail-loading-plan.blade.php
    │   │   ├── edit-loading-plan.blade.php
    │   │   ├── export/
    │   │   │   ├── loading-line-old.blade.php
    │   │   │   ├── loading-line.blade.php
    │   │   │   └── loading.blade.php
    │   │   ├── loading-line.blade.php
    │   │   ├── modify-loading-line.blade.php
    │   │   └── summary-loading.blade.php
    │   ├── loading_out/
    │   │   ├── input_loading_out.blade.php
    │   │   └── loading_out.blade.php
    │   ├── rack/
    │   │   ├── allocate-rack.blade.php
    │   │   ├── create-rack.blade.php
    │   │   ├── pdf/
    │   │   │   └── print-rack.blade.php
    │   │   ├── rack.blade.php
    │   │   ├── stock-rack-visual.blade.php
    │   │   └── stock-rack.blade.php
    │   ├── secondary-in/
    │   │   ├── export/
    │   │   │   ├── secondary-in-detail-excel.blade.php
    │   │   │   └── secondary-in-excel.blade.php
    │   │   └── secondary-in.blade.php
    │   ├── secondary-inhouse/
    │   │   ├── export/
    │   │   │   ├── secondary-inhouse-detail-excel.blade.php
    │   │   │   └── secondary-inhouse-excel.blade.php
    │   │   └── secondary-inhouse.blade.php
    │   ├── stok-dc/
    │   │   ├── stok-dc-complete/
    │   │   │   ├── stok-dc-complete-detail.blade.php
    │   │   │   └── stok-dc-complete.blade.php
    │   │   ├── stok-dc-incomplete/
    │   │   │   ├── stok-dc-incomplete-detail.blade.php
    │   │   │   └── stok-dc-incomplete.blade.php
    │   │   └── stok-dc-wip/
    │   │       ├── stok-dc-wip-detail.blade.php
    │   │       └── stok-dc-wip.blade.php
    │   ├── tools/
    │   │   ├── modify-dc-qty.blade.php
    │   │   └── tools.blade.php
    │   └── trolley/
    │       ├── master-trolley/
    │       │   ├── create-trolley.blade.php
    │       │   ├── pdf/
    │       │   │   └── print-trolley.blade.php
    │       │   └── trolley.blade.php
    │       └── stock-trolley/
    │           ├── allocate-this-trolley.blade.php
    │           ├── allocate-trolley.blade.php
    │           ├── send-stock-trolley.blade.php
    │           └── stock-trolley.blade.php
    ├── employee/
    │   ├── create-employee.blade.php
    │   └── employee.blade.php
    ├── example/
    │   └── timeout.blade.php
    ├── fg-stock/
    │   ├── bpb_fg_stock.blade.php
    │   ├── bppb_fg_stock.blade.php
    │   ├── create_bpb_fg_stock.blade.php
    │   ├── create_bppb_fg_stock.blade.php
    │   ├── create_mutasi_fg_stock.blade.php
    │   ├── export_bpb_fg_stock.blade.php
    │   ├── export_bppb_fg_stock.blade.php
    │   ├── export_mutasi_fg_stock.blade.php
    │   ├── export_mutasi_int_fg_stock.blade.php
    │   ├── laporan_fg_stock.blade.php
    │   ├── master_lokasi_fg_stock.blade.php
    │   ├── master_sumber_penerimaan_fg_stock.blade.php
    │   ├── master_tujuan_pengeluaran_fg_stock.blade.php
    │   └── mutasi_fg_stock.blade.php
    ├── finish_good/
    │   ├── create_finish_good_penerimaan.blade.php
    │   ├── create_finish_good_pengeluaran.blade.php
    │   ├── create_finish_good_retur.blade.php
    │   ├── dashboard_finish_good.blade.php
    │   ├── edit_finish_good_pengeluaran.blade.php
    │   ├── export_finish_good_alokasi.blade.php
    │   ├── export_finish_good_penerimaan_list.blade.php
    │   ├── export_finish_good_penerimaan_summary.blade.php
    │   ├── export_finish_good_pengeluaran_list.blade.php
    │   ├── export_finish_good_pengeluaran_summary.blade.php
    │   ├── export_finish_good_retur_list.blade.php
    │   ├── export_finish_good_retur_summary.blade.php
    │   ├── finish_good_alokasi_Karton.blade.php
    │   ├── finish_good_master_lokasi.blade.php
    │   ├── finish_good_penerimaan.blade.php
    │   ├── finish_good_pengeluaran.blade.php
    │   └── finish_good_retur.blade.php
    ├── ga/
    │   ├── approval_bahan_bakar.blade.php
    │   ├── export_excel_bahan_bakar.blade.php
    │   ├── export_pdf_pengajuan_bhn_bakar.blade.php
    │   └── pengajuan_bahan_bakar.blade.php
    ├── general/
    │   └── tools/
    │       └── tools.blade.php
    ├── home.blade.php
    ├── IE/
    │   ├── dashboard_IE.blade.php
    │   ├── laporan_recap_cm_price.blade.php
    │   ├── laporan_recap_smv.blade.php
    │   ├── master_part_process.blade.php
    │   ├── master_process.blade.php
    │   └── proses_op_breakdown.blade.php
    ├── inmaterial/
    │   ├── create-inmaterial.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-inmaterial.blade.php
    │   ├── in-material.blade.php
    │   ├── lokasi-inmaterial.blade.php
    │   ├── pdf/
    │   │   ├── print-barcode.blade.php
    │   │   └── print-pdf.blade.php
    │   ├── stocker-detail.blade.php
    │   ├── update-lokasi.blade.php
    │   └── upload-lokasi.blade.php
    ├── konfirmasi/
    │   ├── konfirmasi-penerimaan.blade.php
    │   └── konfirmasi-pengeluaran.blade.php
    ├── lap-det-pemasukan/
    │   ├── export.blade.php
    │   ├── export_roll.blade.php
    │   ├── lap_pemasukan.blade - Copy.php
    │   ├── lap_pemasukan.blade.php
    │   └── lap_pemasukan_roll.blade.php
    ├── lap-det-pengeluaran/
    │   ├── export.blade.php
    │   ├── export_roll.blade.php
    │   ├── lap_pengeluaran.blade.php
    │   └── lap_pengeluaran_roll.blade.php
    ├── lap-mutasi-barcode/
    │   ├── export.blade.php
    │   └── lap_mutasi_barcode.blade.php
    ├── lap-mutasi-detail/
    │   ├── export.blade.php
    │   └── lap_mutasi_detail.blade.php
    ├── lap-mutasi-global/
    │   ├── export.blade.php
    │   └── lap_mutasi_global.blade.php
    ├── layouts/
    │   ├── index.blade.php
    │   ├── link.blade.php
    │   ├── navbar.blade.php
    │   ├── offcanvas.blade.php
    │   ├── script.blade.php
    │   └── sidebar.blade.php
    ├── livewire/
    │   ├── cutting/
    │   │   └── track-cutting-output.blade.php
    │   ├── packing/
    │   │   └── track-packing-output.blade.php
    │   ├── qc/
    │   │   ├── inspect/
    │   │   │   └── index.blade.php
    │   │   └── master/
    │   │       ├── defect.blade.php
    │   │       ├── group-inspect.blade.php
    │   │       ├── lenght.blade.php
    │   │       ├── result.blade.php
    │   │       └── satuan.blade.php
    │   └── sewing/
    │       ├── line-dashboard-list.blade.php
    │       ├── line-masterplan.blade.php
    │       ├── report-defect-in-out.blade.php
    │       ├── report-defects.blade.php
    │       ├── report-line-user.blade.php
    │       ├── report-output.blade.php
    │       ├── report-production.blade.php
    │       ├── track-order-output-1.blade.php
    │       ├── track-order-output.blade.php
    │       └── transfer-output.blade.php
    ├── login.blade.php
    ├── maintain-bpb/
    │   ├── create-maintain-bpb.blade.php
    │   ├── detail_modal.blade.php
    │   └── maintain-bpb.blade.php
    ├── management_report/
    │   ├── dashboard_mgt_report.blade.php
    │   ├── export_excel_laporan_daily_cost.blade.php
    │   ├── export_excel_laporan_daily_earn_buyer.blade.php
    │   ├── export_excel_laporan_earning.blade.php
    │   ├── export_excel_laporan_profit_line.blade.php
    │   ├── export_excel_laporan_sum_buyer.blade.php
    │   ├── export_excel_laporan_sum_full_earn.blade.php
    │   ├── export_excel_laporan_sum_prod_earn.blade.php
    │   ├── laporan_daily_cost.blade.php
    │   ├── laporan_daily_earn_buyer.blade.php
    │   ├── laporan_earning.blade.php
    │   ├── laporan_profit_line.blade.php
    │   ├── laporan_sum_buyer.blade.php
    │   ├── laporan_sum_full_earn.blade.php
    │   ├── laporan_sum_prod_earn.blade.php
    │   └── proses_daily_cost.blade.php
    ├── marker/
    │   ├── dashboard.blade.php
    │   ├── marker/
    │   │   ├── create-marker.blade.php
    │   │   ├── edit-marker.blade.php
    │   │   ├── marker.blade.php
    │   │   └── pdf/
    │   │       └── print-marker.blade.php
    │   ├── master-part/
    │   │   └── master-part.blade.php
    │   ├── master-secondary/
    │   │   └── master-secondary.blade.php
    │   └── part/
    │       ├── create-part.blade.php
    │       ├── manage-part-form.blade.php
    │       ├── manage-part-secondary.blade.php
    │       └── part.blade.php
    ├── marketing/
    │   ├── dashboard_marketing.blade.php
    │   ├── edit_costing.blade.php
    │   └── master_costing.blade.php
    ├── master/
    │   ├── create-lokasi.blade.php
    │   ├── dashboard.blade.php
    │   ├── master-lokasi.blade.php
    │   ├── pdf/
    │   │   ├── print-lokasi-all.blade.php
    │   │   └── print-lokasi.blade.php
    │   └── update-lokasi.blade.php
    ├── mut-lokasi/
    │   ├── create-mutlokasi-new.blade.php
    │   ├── create-mutlokasi.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-mutlokasi.blade.php
    │   ├── mut-lokasi-new.blade.php
    │   ├── mut-lokasi.blade.php
    │   └── pdf/
    │       ├── print-barcode.blade.php
    │       └── print-pdf.blade.php
    ├── mut-mesin/
    │   ├── create-mut-mesin.blade.php
    │   ├── create_so_mesin.blade.php
    │   ├── export-master.blade.php
    │   ├── export-stok-mesin-detail.blade.php
    │   ├── export-stok-mesin.blade.php
    │   ├── export.blade.php
    │   ├── lap_stok_detail_mesin.blade.php
    │   ├── lap_stok_mesin.blade.php
    │   ├── master_lokasi_mesin.blade.php
    │   ├── master_mesin.blade.php
    │   ├── mut-mesin.blade.php
    │   └── so_mesin.blade.php
    ├── mutasi-karyawan/
    ├── Mutasi_Karyawan/
    │   └── export.blade.php
    ├── outmaterial/
    │   ├── create-outmaterial.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-inmaterial.blade.php
    │   ├── edit-outmaterial.blade.php
    │   ├── lokasi-inmaterial.blade.php
    │   ├── out-material.blade.php
    │   ├── pdf/
    │   │   ├── print-barcode.blade.php
    │   │   └── print-pdf.blade.php
    │   ├── stocker-detail.blade.php
    │   └── update-lokasi.blade.php
    ├── packing/
    │   ├── create_packing_needle_check.blade.php
    │   ├── create_packing_out.blade.php
    │   ├── create_packing_transfer_garment.blade.php
    │   ├── create_packing_transfer_garment_temporary.blade.php
    │   ├── dashboard_packing.blade.php
    │   ├── export/
    │   │   └── packing-output-export.blade.php
    │   ├── export_excel_data_template_packing_list_horizontal.blade.php
    │   ├── export_excel_data_template_packing_list_vertical.blade.php
    │   ├── export_excel_data_upload.blade.php
    │   ├── export_excel_packing_in.blade.php
    │   ├── export_excel_packing_list.blade.php
    │   ├── export_excel_packing_master_karton.blade.php
    │   ├── export_excel_packing_needle_check.blade.php
    │   ├── export_excel_packing_out.blade.php
    │   ├── export_excel_rep_packing_line_sum_buyer.blade.php
    │   ├── export_excel_rep_packing_line_sum_range.blade.php
    │   ├── export_excel_rep_packing_mutasi.blade.php
    │   ├── export_excel_trf_garment.blade.php
    │   ├── packing_in.blade.php
    │   ├── packing_master_karton.blade.php
    │   ├── packing_needle_check.blade.php
    │   ├── packing_out.blade.php
    │   ├── packing_packing_list.blade.php
    │   ├── packing_rep_packing_line.blade.php
    │   ├── packing_rep_packing_mutasi.blade.php
    │   ├── packing_rep_packing_mutasi_wip.blade.php
    │   ├── packing_transfer_garment.blade.php
    │   └── track-packing-output.blade.php
    ├── ppic/
    │   ├── adj_mut_output.blade.php
    │   ├── barcode-packing/
    │   │   ├── barcode-packing.blade.php
    │   │   └── export/
    │   │       └── barcode-packing-pdf.blade.php
    │   ├── dashboard_ppic.blade.php
    │   ├── export_excel_tracking.blade.php
    │   ├── export_master_so_ppic.blade.php
    │   ├── export_master_so_sb.blade.php
    │   ├── laporan_tracking.blade.php
    │   ├── master_so.blade.php
    │   ├── monitoring_material.blade.php
    │   ├── monitoring_material_det.blade.php
    │   ├── monitoring_material_sum.blade.php
    │   ├── monitoring_order.blade.php
    │   └── report_hourly.blade.php
    ├── procurement/
    │   ├── detail-return-sb.blade.php
    │   ├── export_detail.blade.php
    │   └── homepage.blade.php
    ├── qc/
    │   └── inspect/
    │       ├── generateRoll.blade.php
    │       └── index.blade.php
    ├── qc-pass/
    │   ├── create-qcpass.blade.php
    │   ├── dashboard.blade.php
    │   ├── excel/
    │   │   └── export-qcpass.blade.php
    │   ├── pdf/
    │   │   ├── pdf-qcpass.blade.php
    │   │   └── print-lokasi.blade.php
    │   ├── qc-pass.blade.php
    │   ├── show-qcpass.blade.php
    │   └── update-lokasi.blade.php
    ├── qc_inspect/
    │   ├── dashboard_qc_inspect.blade.php
    │   ├── export_excel_qc_inspect_lot.blade.php
    │   ├── export_excel_qc_inspect_roll.blade.php
    │   ├── laporan_qc_inspect_lot.blade.php
    │   ├── laporan_qc_inspect_roll.blade.php
    │   ├── master_critical_defect.blade.php
    │   ├── master_founding_issue.blade.php
    │   ├── pdf_list_defect.blade.php
    │   ├── pdf_print_bintex_shade_band.blade.php
    │   ├── pdf_print_group_shade_band.blade.php
    │   ├── pdf_qc_inspect.blade.php
    │   ├── pdf_qc_inspect_print_fabric_relaxation.blade.php
    │   ├── pdf_qc_inspect_print_sticker.blade.php
    │   ├── pdf_report_shade_band.blade.php
    │   ├── proses_det_form_inspect.blade.php
    │   ├── proses_det_packinglist.blade.php
    │   ├── proses_fabric_relaxation.blade.php
    │   ├── proses_form_inspect.blade.php
    │   ├── proses_input_fabric_relaxation.blade.php
    │   ├── proses_input_fabric_relaxation_det.blade.php
    │   ├── proses_input_shade_band.blade.php
    │   ├── proses_packinglist.blade.php
    │   ├── proses_print_bintex_shade_band.blade.php
    │   ├── proses_shade_band.blade.php
    │   ├── report_shade_band.blade.php
    │   └── report_shade_band_add.blade.php
    ├── report_doc/
    │   └── laporan_wip.blade.php
    ├── reqmaterial/
    │   ├── create-reqmaterial.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-reqmaterial.blade.php
    │   ├── lokasi-inmaterial.blade.php
    │   ├── pdf/
    │   │   ├── print-barcode.blade.php
    │   │   └── print-pdf.blade.php
    │   ├── req-material.blade.php
    │   ├── stocker-detail.blade.php
    │   └── update-lokasi.blade.php
    ├── returmaterial/
    │   ├── barcode-ro.blade.php
    │   ├── create-returmaterial.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-inmaterial.blade.php
    │   ├── lokasi-inmaterial.blade.php
    │   ├── pdf/
    │   │   ├── print-barcode.blade.php
    │   │   └── print-pdf.blade.php
    │   ├── retur-material.blade.php
    │   ├── stocker-detail.blade.php
    │   └── update-lokasi.blade.php
    ├── retur_inmaterial/
    │   ├── barcode-ro.blade.php
    │   ├── create-retur-inmaterial-cutting.blade.php
    │   ├── create-retur-inmaterial.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-inmaterial.blade.php
    │   ├── lokasi-inmaterial.blade.php
    │   ├── pdf/
    │   │   ├── print-barcode.blade.php
    │   │   └── print-pdf.blade.php
    │   ├── retur-inmaterial.blade.php
    │   ├── stocker-detail.blade.php
    │   ├── update-lokasi.blade.php
    │   └── upload-lokasi.blade.php
    ├── revise QR/
    │   └── reviseQR.blade.php
    ├── roles/
    │   └── roles.blade.php
    ├── sewing/
    │   ├── dashboard-line.blade.php
    │   ├── dashboard.blade.php
    │   ├── defect/
    │   │   ├── defect-map.blade.php
    │   │   └── defect-rate.blade.php
    │   ├── export/
    │   │   ├── chief-sewing-range-export.blade.php
    │   │   ├── defect-in-out-export.blade.php
    │   │   ├── defect-in-out-finishing-export.blade.php
    │   │   ├── defect-rate-export.blade.php
    │   │   ├── leader-sewing-range-export.blade.php
    │   │   ├── line-wip-export.blade.php
    │   │   ├── master-line-export.blade.php
    │   │   ├── order-output-export.blade.php
    │   │   ├── output-export-custom-range.blade.php
    │   │   ├── output-export.blade.php
    │   │   ├── production-export-defect.blade.php
    │   │   ├── production-export.blade.php
    │   │   ├── report-hourly-export.blade.php
    │   │   ├── report-reject-export.blade.php
    │   │   ├── report_efficiency_new_export.blade.php
    │   │   ├── top-defect-export.blade.php
    │   │   └── top-reject-export.blade.php
    │   ├── input-output.blade.php
    │   ├── line-wip.blade.php
    │   ├── master-defect/
    │   │   └── master-defect.blade.php
    │   ├── master-line/
    │   │   ├── create-master-line.blade.php
    │   │   └── master-line.blade.php
    │   ├── master-plan/
    │   │   ├── master-plan-detail.blade.php
    │   │   └── master-plan.blade.php
    │   ├── order-defects.blade.php
    │   ├── pdf/
    │   │   └── print-line-label.blade.php
    │   ├── production/
    │   │   ├── detail-production-day.blade.php
    │   │   ├── detail-production.blade.php
    │   │   └── production.blade.php
    │   ├── report/
    │   │   ├── excel/
    │   │   │   ├── detail-output-excel.blade.php
    │   │   │   ├── detail-output-packing-excel.blade.php
    │   │   │   ├── efficiency-excel.blade.php
    │   │   │   ├── efficiency-excel1.blade.php
    │   │   │   ├── output-excel.blade.php
    │   │   │   └── production-excel.blade.php
    │   │   ├── report-defect.blade.php
    │   │   ├── report-detail-output.blade.php
    │   │   ├── report-efficiency.blade.php
    │   │   ├── report-output.blade.php
    │   │   ├── report-production.blade.php
    │   │   ├── report-reject.blade.php
    │   │   ├── report_efficiency_new.blade.php
    │   │   └── report_mutasi_output.blade.php
    │   ├── report-defect-in-out.blade.php
    │   ├── report.blade.php
    │   ├── tools/
    │   │   ├── check-output-detail.blade.php
    │   │   ├── export/
    │   │   │   └── check-output-detail-export.blade.php
    │   │   ├── line-migration.blade.php
    │   │   ├── modify-output.blade.php
    │   │   ├── summary-output.blade.php
    │   │   ├── tools.blade.php
    │   │   ├── undo-defect-in-out.blade.php
    │   │   ├── undo-output.blade.php
    │   │   └── undo-reject.blade.php
    │   ├── track-order-output.blade.php
    │   ├── transfer-output.blade.php
    │   └── undo/
    │       └── undo-output-history.blade.php
    ├── stocker/
    │   ├── part/
    │   │   ├── create-part.blade.php
    │   │   ├── manage-part-form.blade.php
    │   │   ├── manage-part-secondary.blade.php
    │   │   └── part.blade.php
    │   ├── stocker/
    │   │   ├── dashboard.blade.php
    │   │   ├── export/
    │   │   │   ├── stocker-list-detail-export.blade.php
    │   │   │   └── stocker-list-export.blade.php
    │   │   ├── modify-year-sequence.blade.php
    │   │   ├── month-count.blade.php
    │   │   ├── pdf/
    │   │   │   ├── print-numbering-yearmonth-1.blade.php
    │   │   │   ├── print-numbering-yearmonth.blade.php
    │   │   │   ├── print-numbering-yearsequence-1-new.blade.php
    │   │   │   ├── print-numbering-yearsequence-1.blade.php
    │   │   │   ├── print-numbering-yearsequence.blade.php
    │   │   │   ├── print-numbering.blade.php
    │   │   │   ├── print-stocker-redundant.blade.php
    │   │   │   ├── print-stocker-reject.blade.php
    │   │   │   ├── print-stocker.blade.php
    │   │   │   ├── print-year-sequence-stock.blade.php
    │   │   │   └── print-year-sequence-stocks.blade.php
    │   │   ├── stocker-detail-part-additional.blade.php
    │   │   ├── stocker-detail-part.blade.php
    │   │   ├── stocker-detail-separate.blade.php
    │   │   ├── stocker-detail.blade.php
    │   │   ├── stocker-list-detail.blade.php
    │   │   ├── stocker-list.blade.php
    │   │   ├── stocker-piece-detail-part.blade.php
    │   │   ├── stocker-piece-detail-separate.blade.php
    │   │   ├── stocker-piece-detail.blade.php
    │   │   ├── stocker.blade.php
    │   │   └── year-sequence.blade.php
    │   └── tools/
    │       └── tools.blade.php
    ├── stock_opname/
    │   ├── data-rak.blade.php
    │   ├── detail-stok-opname.blade.php
    │   ├── export.blade.php
    │   ├── export_detail.blade.php
    │   ├── export_detail_barcode.blade.php
    │   ├── export_detail_trans.blade.php
    │   ├── homepage.blade.php
    │   ├── laporan-stok-opname.blade.php
    │   ├── list-data-opname.blade.php
    │   ├── pdf/
    │   │   └── print-qr.blade.php
    │   ├── proses-scan-so.blade.php
    │   ├── show-detail-so.blade.php
    │   ├── stok-opname.blade.php
    │   └── worksheet.blade.php
    ├── summary.blade.php
    ├── track/
    │   ├── stocker/
    │   │   ├── export/
    │   │   │   └── stocker.blade.php
    │   │   ├── stocker-detail.blade.php
    │   │   └── stocker.blade.php
    │   └── worksheet/
    │       ├── export/
    │       │   ├── worksheet.blade.php
    │       │   └── worksheet_grouping.blade.php
    │       ├── worksheet-detail.blade.php
    │       └── worksheet.blade.php
    ├── transfer-bpb/
    │   ├── create-transfer-bpb.blade.php
    │   ├── dashboard.blade.php
    │   ├── edit-mutlokasi.blade.php
    │   ├── pdf/
    │   │   ├── print-barcode.blade.php
    │   │   └── print-pdf.blade.php
    │   └── transfer-bpb.blade.php
    ├── users/
    │   └── users.blade.php
    ├── user_lines/
    │   └── user_lines.blade.php
    ├── warehouse/
    │   ├── dashboard.blade.php
    │   ├── pdf/
    │   │   ├── print-numbering.blade.php
    │   │   └── print-stocker.blade.php
    │   ├── stocker-detail.blade.php
    │   └── warehouse.blade.php
    ├── wip/
    │   ├── dashboard-chief-leader-sewing-diff.blade.php
    │   ├── dashboard-chief-leader-sewing.blade.php
    │   ├── dashboard-chief-sewing-range.blade.php
    │   ├── dashboard-chief-sewing-single.blade.php
    │   ├── dashboard-chief-sewing-slide.blade.php
    │   ├── dashboard-chief-sewing.blade.php
    │   ├── dashboard-chief-support-sewing.blade.php
    │   ├── dashboard-factory-daily-sewing.blade.php
    │   ├── dashboard-factory-performance-sewing.blade.php
    │   ├── dashboard-leader-sewing.blade.php
    │   ├── dashboard-support-line-sewing.blade.php
    │   ├── dashboard-top-chief-sewing.blade.php
    │   ├── dashboard-top-leader-sewing.blade.php
    │   ├── dashboard-wip.blade.php
    │   └── wip-line.blade.php
    └── worksheet/
        ├── pdf/
        │   └── print-qr.blade.php
        └── worksheet.blade.php
```

### routes/
```
├── api.php
├── channels.php
├── console.php
├── qc_inspect.php
└── web.php
```