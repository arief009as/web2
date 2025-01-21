SELECT 
  [KANBAN_ORDER], 
  [KANBAN_SERIAL_NO], 
  [BACK_NO], 
  [RECEIVING_AREA_CODE], 
  [DEPOT_CODE1], 
  [DEPOT_CODE2], 
  [PLANT_CODE], 
  [MAKER_CODE], 
  [INSPECT_CODE], 
  [VENDOR_GROUP], 
  [PALLETIZE_MARK_CODE], 
  [FLAG], 
  [ORDER_TIME], 
  [PO_DATE], 
  [DELIVERYDATE], 
  [DELIVERY_DATE], 
  [DELIVERY_DATE_DN], 
  [DELIVERY_TIME], 
  [DELIVERY_NOTE_BARCODE_SEQUENCE], 
  [DELIVERY_UNIT_DN], 
  [DELIVERY_UNIT_KBN], 
  [DELIVERY_NOTE_NUMBER], 
  [TOP_6_DIGITS_OF_KATASHIKI], 
  [PO_NO], 
  [P_NO], 
  [PO_ITEM_NO], 
  [PO_QTY], 
  [OO_QTY], 
  [PART_NAME], 
  [SUPP_NAME], 
  [SUPP_CODE], 
  [SUPP_ADDRESS2], 
  [SUPPLIER_PNO], 
  [SUPPLIER_MANAGER], 
  [SUPPLIER_STORE], 
  [LOCATION_NO], 
  [PERIOD1], 
  [PERIOD2], 
  [KBN_CY01], 
  [KBN_CY02], 
  [KBN_CY03], 
  [INNER_PCKG_MATERIAL_PNO_1], 
  [INNER_PCKG_MATERIAL_PNO_2], 
  [INNER_PACKAGING_TYPE_3], 
  [N_1_M_PRELIM_ORD_QTY], 
  [N_2_M_PRELIM_ORD_QTY], 
  [N_3_M_PRELIM_ORD_QTY], 
  [D1], 
  [D2], 
  [D3], 
  [D4], 
  [D5], 
  [D6], 
  [D7], 
  [D8], 
  [D9], 
  [D10], 
  [D11], 
  [D12], 
  [D13], 
  [D14], 
  [D15], 
  [D16], 
  [D17], 
  [D18], 
  [D19], 
  [D20], 
  [D21], 
  [D22], 
  [D23], 
  [D24], 
  [D25], 
  [D26], 
  [D27], 
  [D28], 
  [D29], 
  [D30], 
  [D31], 
  [D1M], 
  [D2M], 
  [D3M], 
  [D4M], 
  [D5M], 
  [D6M], 
  [D7M], 
  [D8M], 
  [D9M], 
  [D10M], 
  [D11M], 
  [D12M], 
  [D13M], 
  [D14M], 
  [D15M], 
  [D16M], 
  [D17M], 
  [D18M], 
  [D19M], 
  [D20M], 
  [D21M], 
  [D22M], 
  [D23M], 
  [D24M], 
  [D25M], 
  [D26M], 
  [D27M], 
  [D28M], 
  [D29M], 
  [D30M], 
  [D31M] 
FROM 
  (
    SELECT 
      [NOTE].*, 
      [DISTR].[OO_QTY], 
      [POQ].[N_1_M_PRELIM_ORD_QTY], 
      [POQ].[N_2_M_PRELIM_ORD_QTY], 
      [POQ].[N_3_M_PRELIM_ORD_QTY], 
      COALESCE(
        [DISTR].[TOP_6_DIGITS_OF_KATASHIKI], 
        [NOTE].[TOP_6_DIGITS_OF_KATASHIKI_]
      ) [TOP_6_DIGITS_OF_KATASHIKI] 
    FROM 
      (
        SELECT 
          [DELIVERY_NOTE].*, 
          [SUPPLIER].[VENDOR_GROUP], 
          [SUPPLIER].[PLANT_CODE], 
          [SUPPLIER].[SUPP_NAME], 
          [SUPPLIER].[SUPP_ADDRESS2], 
          [SUPPLIER].[SUPPLIER_MANAGER], 
          STUFF(
            (
              SELECT 
                TOP 3 CONCAT(
                  ',', [TOP_6_DIGITS_OF_KATASHIKI]
                ) 
              FROM 
                [DB_SP_INF].[dbo].[TB_I_H01_34_TOP6_KATASHIKI] 
              WHERE 
                [MAKER_CODE] = [DELIVERY_NOTE].[MAKER_CODE] 
                AND [PNO] = [DELIVERY_NOTE].[PO_PNO] FOR XML PATH(''), 
                TYPE
            ).value('.', 'NVARCHAR(MAX)'), 
            1, 
            1, 
            ''
          ) [TOP_6_DIGITS_OF_KATASHIKI_] 
        FROM 
          (
            SELECT 
              [DEPOT_CODE], 
              [MAKER_CODE], 
              [FACTORY_CODE], 
              [PALLETIZE_CODE] [PALLETIZE_MARK_CODE], 
              [PO_NO], 
              [PO_PNO], 
              [PO_ITEM_NO], 
              [PO_QTY], 
              [PO_DATE], 
              [DELIVERY_DATE] [DELIVERY_DATE_DN], 
              [DELIVERY_UNIT] [DELIVERY_UNIT_DN], 
              [KANBAN_ORDER], 
              [DELIVERY_NOTE_NUMBER], 
              [SUPPLIER_PNO], 
              [SUPPLIER_CODE] 
            FROM 
              [TB_R_KANBAN_DELIVERY_NOTE]
          ) [DELIVERY_NOTE] 
          INNER JOIN (
            SELECT 
              [DEPOT_CODE], 
              [FACTORY_CODE], 
              [SUPP].[PLANT_CODE], 
              [SUPP].[VENDOR_GROUP], 
              [SUPPLIER_CODE], 
              [SUPPLIER_PIC], 
              [SUPPLIER_NAME] [SUPP_NAME], 
              [SUPPLIER_ADDRESS], 
              [SUPPLIER_MANAGER] [SUPP_ADDRESS2], 
              [SUPPLIER_PHONE_NO], 
              [SUPPLIER_FAX_NO], 
              [SUPPLIER_MANAGER] 
            FROM 
              [DB_SP_WRH].[dbo].[TB_M_SUPPLIER] [SUPP] 
              INNER JOIN [DB_SP_WRH].[dbo].[TB_M_PLANT] [PLANT] ON [SUPP].[PLANT_CODE] = [PLANT].[PLANT_CODE] 
            WHERE 
              [SUPP].[IS_PORTAL] = 1 
              AND [SUPP].[IS_DELETED] = 0
          ) [SUPPLIER] ON [DELIVERY_NOTE].[SUPPLIER_CODE] = [SUPPLIER].[SUPPLIER_CODE] 
          AND [DELIVERY_NOTE].[DEPOT_CODE] = [SUPPLIER].[DEPOT_CODE] 
          AND [DELIVERY_NOTE].[FACTORY_CODE] = [SUPPLIER].[FACTORY_CODE]
      ) [NOTE] 
      LEFT JOIN (
        SELECT 
          [DEPOT_CODE], 
          [MAKER_CODE], 
          [FACTORY_CODE], 
          [SUPP_CODE], 
          [PNO], 
          [PERIOD], 
          [N_1_M_PRELIM_ORD_QTY], 
          [N_2_M_PRELIM_ORD_QTY], 
          [N_3_M_PRELIM_ORD_QTY] 
        FROM 
          [TB_R_POQ]
      ) [POQ] ON [NOTE].[DEPOT_CODE] = [POQ].[DEPOT_CODE] 
      AND [NOTE].[SUPPLIER_CODE] = [POQ].[SUPP_CODE] 
      AND [NOTE].[FACTORY_CODE] = [POQ].[FACTORY_CODE] 
      AND [NOTE].[MAKER_CODE] = [POQ].[MAKER_CODE] 
      AND [NOTE].[PO_PNO] = [POQ].[PNO] 
      AND LEFT(
        CONVERT(
          VARCHAR, 
          DATEADD(MONTH, 1, [NOTE].[PO_DATE]), 
          112
        ), 
        6
      ) = [POQ].[PERIOD] 
      LEFT JOIN (
        SELECT 
          [STK_DISTR].[DEPOT_CODE], 
          [STK_DISTR].[MAKER_CODE], 
          [STK_DISTR].[PNO], 
          [STK_DISTR].[PART_NAME], 
          [STK_DISTR].[OO_QTY], 
          [STK_DISTR].[MAD], 
          [STORAGE].[LOCATION_NO], 
          [BASIC].[INVENTORY_CONTROL_CLASS], 
          [STOCK].[STOCK_QTY], 
          [STK_DISTR].[TOP_6_DIGITS_OF_KATASHIKI] 
        FROM 
          (
            SELECT 
              [DEPOT_CODE], 
              [MAKER_CODE], 
              [DISTR_MAIN].[PNO], 
              [PART_NAME], 
              [OO_QTY], 
              [MAD], 
              STUFF(
                (
                  SELECT 
                    TOP 3 CONCAT(
                      ',', [TOP_6_DIGITS_OF_KATASHIKI]
                    ) 
                  FROM 
                    [DB_SP_INF].[dbo].[TB_I_H01_34_TOP6_KATASHIKI] 
                  WHERE 
                    [MAKER_CODE] = [DISTR_MAIN].[MAKER_CODE] 
                    AND [PNO] = [DISTR_MAIN].[PNO] FOR XML PATH(''), 
                    TYPE
                ).value('.', 'NVARCHAR(MAX)'), 
                1, 
                1, 
                ''
              ) [TOP_6_DIGITS_OF_KATASHIKI] 
            FROM 
              (
                SELECT 
                  [DEPOT_CODE], 
                  [MAKER_CODE], 
                  [PNO], 
                  [TARGET_DATE_], 
                  [PART_NAME], 
                  (
                    COALESCE([OO_OTHERS_QTY], 0) + COALESCE([OO_AIR_QTY], 0)
                  ) [OO_QTY], 
                  [MAD] 
                FROM 
                  [DB_SP_INF].[dbo].[TB_I_H02_35_PNO_STK_DISTR]
              ) [DISTR_MAIN] 
              INNER JOIN (
                SELECT 
                  MAX([TARGET_DATE_]) [TARGET_DATE_], 
                  [PNO] 
                FROM 
                  [DB_SP_INF].[dbo].[TB_I_H02_35_PNO_STK_DISTR] GROUP BY[PNO]
              ) [DISTR_MAX] ON [DISTR_MAIN].[PNO] = [DISTR_MAX].[PNO] 
              AND [DISTR_MAIN].[TARGET_DATE_] = [DISTR_MAX].[TARGET_DATE_]
          ) [STK_DISTR] 
          LEFT OUTER JOIN (
            SELECT 
              SUBSTRING([LOCATION_NO], 0, 2) [LOCATION_NO], 
              [DEPOT_CODE], 
              [MAKER_CODE], 
              [P_NO] 
            FROM 
              [DB_SP_INF].[dbo].[TB_I_H01_12_STORAGE] 
            WHERE 
              [LOCATION_CODE] = 1 
              AND [LOCATION_CODE_SERIAL_NO] = 0
          ) [STORAGE] ON [STORAGE].[DEPOT_CODE] = [STK_DISTR].[DEPOT_CODE] 
          AND [STORAGE].[MAKER_CODE] = [STK_DISTR].[MAKER_CODE] 
          AND [STORAGE].[P_NO] = [STK_DISTR].[PNO] 
          LEFT OUTER JOIN (
            SELECT 
              [INVENTORY_CONTROL_CLASS], 
              [DEPOT_CODE], 
              [MAKER_CODE], 
              [PNO] 
            FROM 
              [DB_SP_INF].[dbo].[TB_I_H01_03_PROC_BASIC]
          ) [BASIC] ON [BASIC].[DEPOT_CODE] = [STK_DISTR].[DEPOT_CODE] 
          AND [BASIC].[MAKER_CODE] = [STK_DISTR].[MAKER_CODE] 
          AND [BASIC].[PNO] = [STK_DISTR].[PNO] 
          LEFT OUTER JOIN (
            SELECT 
              [STOCK_QTY], 
              [DEPOT_CODE], 
              [MAKER_CODE], 
              [P_NO] 
            FROM 
              [DB_SP_INF].[dbo].[TB_I_H02_01_STOCK_FILE]
          ) [STOCK] ON [STOCK].[DEPOT_CODE] = [STK_DISTR].[DEPOT_CODE] 
          AND [STOCK].[MAKER_CODE] = [STK_DISTR].[MAKER_CODE] 
          AND [STOCK].[P_NO] = [STK_DISTR].[PNO]
      ) [DISTR] ON [NOTE].[DEPOT_CODE] = [DISTR].[DEPOT_CODE] 
      AND [NOTE].[MAKER_CODE] = [DISTR].[MAKER_CODE] 
      AND [NOTE].[PO_PNO] = [DISTR].[PNO]
  ) [DELIVERY] 
  INNER JOIN (
    SELECT 
      [MAKER_CODE] [FRANCHISE], 
      [PO_DATE] [DELIVERYDATE], 
      [ITEM_NO] [ITEMNO], 
      [PO_NO] [PONUM], 
      [PNO] [PARTNO], 
      [PO_QTY] [ORDERQTY], 
      [DELIVERY_PERIOD_M] [PERIOD1], 
      [DELIVERY_PERIOD_M1] [PERIOD2], 
      [VEND_ADJ_DLV_QTY01] [D1], 
      [VEND_ADJ_DLV_QTY02] [D2], 
      [VEND_ADJ_DLV_QTY03] [D3], 
      [VEND_ADJ_DLV_QTY04] [D4], 
      [VEND_ADJ_DLV_QTY05] [D5], 
      [VEND_ADJ_DLV_QTY06] [D6], 
      [VEND_ADJ_DLV_QTY07] [D7], 
      [VEND_ADJ_DLV_QTY08] [D8], 
      [VEND_ADJ_DLV_QTY09] [D9], 
      [VEND_ADJ_DLV_QTY10] [D10], 
      [VEND_ADJ_DLV_QTY11] [D11], 
      [VEND_ADJ_DLV_QTY12] [D12], 
      [VEND_ADJ_DLV_QTY13] [D13], 
      [VEND_ADJ_DLV_QTY14] [D14], 
      [VEND_ADJ_DLV_QTY15] [D15], 
      [VEND_ADJ_DLV_QTY16] [D16], 
      [VEND_ADJ_DLV_QTY17] [D17], 
      [VEND_ADJ_DLV_QTY18] [D18], 
      [VEND_ADJ_DLV_QTY19] [D19], 
      [VEND_ADJ_DLV_QTY20] [D20], 
      [VEND_ADJ_DLV_QTY21] [D21], 
      [VEND_ADJ_DLV_QTY22] [D22], 
      [VEND_ADJ_DLV_QTY23] [D23], 
      [VEND_ADJ_DLV_QTY24] [D24], 
      [VEND_ADJ_DLV_QTY25] [D25], 
      [VEND_ADJ_DLV_QTY26] [D26], 
      [VEND_ADJ_DLV_QTY27] [D27], 
      [VEND_ADJ_DLV_QTY28] [D28], 
      [VEND_ADJ_DLV_QTY29] [D29], 
      [VEND_ADJ_DLV_QTY30] [D30], 
      [VEND_ADJ_DLV_QTY31] [D31], 
      [VEND_ADJ_N1_DLV_QTY01] [D1M], 
      [VEND_ADJ_N1_DLV_QTY02] [D2M], 
      [VEND_ADJ_N1_DLV_QTY03] [D3M], 
      [VEND_ADJ_N1_DLV_QTY04] [D4M], 
      [VEND_ADJ_N1_DLV_QTY05] [D5M], 
      [VEND_ADJ_N1_DLV_QTY06] [D6M], 
      [VEND_ADJ_N1_DLV_QTY07] [D7M], 
      [VEND_ADJ_N1_DLV_QTY08] [D8M], 
      [VEND_ADJ_N1_DLV_QTY09] [D9M], 
      [VEND_ADJ_N1_DLV_QTY10] [D10M], 
      [VEND_ADJ_N1_DLV_QTY11] [D11M], 
      [VEND_ADJ_N1_DLV_QTY12] [D12M], 
      [VEND_ADJ_N1_DLV_QTY13] [D13M], 
      [VEND_ADJ_N1_DLV_QTY14] [D14M], 
      [VEND_ADJ_N1_DLV_QTY15] [D15M], 
      [VEND_ADJ_N1_DLV_QTY16] [D16M], 
      [VEND_ADJ_N1_DLV_QTY17] [D17M], 
      [VEND_ADJ_N1_DLV_QTY18] [D18M], 
      [VEND_ADJ_N1_DLV_QTY19] [D19M], 
      [VEND_ADJ_N1_DLV_QTY20] [D20M], 
      [VEND_ADJ_N1_DLV_QTY21] [D21M], 
      [VEND_ADJ_N1_DLV_QTY22] [D22M], 
      [VEND_ADJ_N1_DLV_QTY23] [D23M], 
      [VEND_ADJ_N1_DLV_QTY24] [D24M], 
      [VEND_ADJ_N1_DLV_QTY25] [D25M], 
      [VEND_ADJ_N1_DLV_QTY26] [D26M], 
      [VEND_ADJ_N1_DLV_QTY27] [D27M], 
      [VEND_ADJ_N1_DLV_QTY28] [D28M], 
      [VEND_ADJ_N1_DLV_QTY29] [D29M], 
      [VEND_ADJ_N1_DLV_QTY30] [D30M], 
      [VEND_ADJ_N1_DLV_QTY31] [D31M], 
      'vendor' [FLAG], 
      1 [MONTHSEQ] 
    FROM 
      [TB_R_DDD] 
    UNION 
    SELECT 
      [MAKER_CODE] [FRANCHISE], 
      [PO_DATE] [DELIVERYDATE], 
      [ITEM_NO] [ITEMNO], 
      [PO_NO] [PONUM], 
      [PNO] [PARTNO], 
      [PO_QTY] [ORDERQTY], 
      [DELIVERY_PERIOD_M] [PERIOD1], 
      [DELIVERY_PERIOD_M1] [PERIOD2], 
      [ORI_TAM_ADJ_DLV_QTY01] [D1], 
      [ORI_TAM_ADJ_DLV_QTY02] [D2], 
      [ORI_TAM_ADJ_DLV_QTY03] [D3], 
      [ORI_TAM_ADJ_DLV_QTY04] [D4], 
      [ORI_TAM_ADJ_DLV_QTY05] [D5], 
      [ORI_TAM_ADJ_DLV_QTY06] [D6], 
      [ORI_TAM_ADJ_DLV_QTY07] [D7], 
      [ORI_TAM_ADJ_DLV_QTY08] [D8], 
      [ORI_TAM_ADJ_DLV_QTY09] [D9], 
      [ORI_TAM_ADJ_DLV_QTY10] [D10], 
      [ORI_TAM_ADJ_DLV_QTY11] [D11], 
      [ORI_TAM_ADJ_DLV_QTY12] [D12], 
      [ORI_TAM_ADJ_DLV_QTY13] [D13], 
      [ORI_TAM_ADJ_DLV_QTY14] [D14], 
      [ORI_TAM_ADJ_DLV_QTY15] [D15], 
      [ORI_TAM_ADJ_DLV_QTY16] [D16], 
      [ORI_TAM_ADJ_DLV_QTY17] [D17], 
      [ORI_TAM_ADJ_DLV_QTY18] [D18], 
      [ORI_TAM_ADJ_DLV_QTY19] [D19], 
      [ORI_TAM_ADJ_DLV_QTY20] [D20], 
      [ORI_TAM_ADJ_DLV_QTY21] [D21], 
      [ORI_TAM_ADJ_DLV_QTY22] [D22], 
      [ORI_TAM_ADJ_DLV_QTY23] [D23], 
      [ORI_TAM_ADJ_DLV_QTY24] [D24], 
      [ORI_TAM_ADJ_DLV_QTY25] [D25], 
      [ORI_TAM_ADJ_DLV_QTY26] [D26], 
      [ORI_TAM_ADJ_DLV_QTY27] [D27], 
      [ORI_TAM_ADJ_DLV_QTY28] [D28], 
      [ORI_TAM_ADJ_DLV_QTY29] [D29], 
      [ORI_TAM_ADJ_DLV_QTY30] [D30], 
      [ORI_TAM_ADJ_DLV_QTY31] [D31], 
      [ORI_TAM_ADJ_N1_DLV_QTY01] [D1M], 
      [ORI_TAM_ADJ_N1_DLV_QTY02] [D2M], 
      [ORI_TAM_ADJ_N1_DLV_QTY03] [D3M], 
      [ORI_TAM_ADJ_N1_DLV_QTY04] [D4M], 
      [ORI_TAM_ADJ_N1_DLV_QTY05] [D5M], 
      [ORI_TAM_ADJ_N1_DLV_QTY06] [D6M], 
      [ORI_TAM_ADJ_N1_DLV_QTY07] [D7M], 
      [ORI_TAM_ADJ_N1_DLV_QTY08] [D8M], 
      [ORI_TAM_ADJ_N1_DLV_QTY09] [D9M], 
      [ORI_TAM_ADJ_N1_DLV_QTY10] [D10M], 
      [ORI_TAM_ADJ_N1_DLV_QTY11] [D11M], 
      [ORI_TAM_ADJ_N1_DLV_QTY12] [D12M], 
      [ORI_TAM_ADJ_N1_DLV_QTY13] [D13M], 
      [ORI_TAM_ADJ_N1_DLV_QTY14] [D14M], 
      [ORI_TAM_ADJ_N1_DLV_QTY15] [D15M], 
      [ORI_TAM_ADJ_N1_DLV_QTY16] [D16M], 
      [ORI_TAM_ADJ_N1_DLV_QTY17] [D17M], 
      [ORI_TAM_ADJ_N1_DLV_QTY18] [D18M], 
      [ORI_TAM_ADJ_N1_DLV_QTY19] [D19M], 
      [ORI_TAM_ADJ_N1_DLV_QTY20] [D20M], 
      [ORI_TAM_ADJ_N1_DLV_QTY21] [D21M], 
      [ORI_TAM_ADJ_N1_DLV_QTY22] [D22M], 
      [ORI_TAM_ADJ_N1_DLV_QTY23] [D23M], 
      [ORI_TAM_ADJ_N1_DLV_QTY24] [D24M], 
      [ORI_TAM_ADJ_N1_DLV_QTY25] [D25M], 
      [ORI_TAM_ADJ_N1_DLV_QTY26] [D26M], 
      [ORI_TAM_ADJ_N1_DLV_QTY27] [D27M], 
      [ORI_TAM_ADJ_N1_DLV_QTY28] [D28M], 
      [ORI_TAM_ADJ_N1_DLV_QTY29] [D29M], 
      [ORI_TAM_ADJ_N1_DLV_QTY30] [D30M], 
      [ORI_TAM_ADJ_N1_DLV_QTY31] [D31M], 
      'tam' [FLAG], 
      1 [MONTHSEQ] 
    FROM 
      [TB_R_DDD]
  ) [DDD] ON [DELIVERY].[PO_NO] = [DDD].[PONUM] 
  AND [DELIVERY].[PO_PNO] = [DDD].[PARTNO] 
  AND [DELIVERY].[PO_ITEM_NO] = [DDD].[ITEMNO] 
  INNER JOIN (
    SELECT 
      [KANBAN_SERIAL_NO], 
      [BACK_NO], 
      [PO_NO] [PO_NO_], 
      [P_NO], 
      [PO_ITEM_NO] [PO_ITEM_NO_], 
      [DEPOT_CODE] [DEPOT_CODE1], 
      [DEPOT_CODE] [DEPOT_CODE2], 
      [RECEIVING_AREA_CODE], 
      [INSPECT_CODE], 
      [SUPP_CODE], 
      [SUPPLIER_STORE], 
      CAST(
        [LOCATION_NO] AS CHAR(8)
      ) [LOCATION_NO], 
      [PART_NAME], 
      [ORDER_TIME], 
      [DELIVERY_TIME], 
      [DELIVERY_DATE], 
      [DELIVERY_UNIT] [DELIVERY_UNIT_KBN], 
      [DELIVERY_NOTE_BARCODE_SEQUENCE], 
      --[PO_DATE]
      SUBSTRING([KANBAN_CYCLE], 1, 1) [KBN_CY01], 
      SUBSTRING([KANBAN_CYCLE], 2, 2) [KBN_CY02], 
      SUBSTRING([KANBAN_CYCLE], 4, 2) [KBN_CY03], 
      [INNER_PCKG_MATERIAL_PNO_1], 
      [INNER_PCKG_MATERIAL_PNO_2], 
      [INNER_PACKAGING_TYPE_3] 
    FROM 
      [TB_R_KANBAN_CARD]
  ) [CARD] ON [DELIVERY].[PO_NO] = [CARD].[PO_NO_] 
  AND [DELIVERY].[PO_PNO] = [CARD].[P_NO] 
  AND [DELIVERY].[PO_ITEM_NO] = [CARD].[PO_ITEM_NO_];
