/*
 * This file is generated by jOOQ.
 */
package com.ftpix.sss.dsl.tables;


import com.ftpix.sss.dsl.Indexes;
import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.Sss;
import com.ftpix.sss.dsl.tables.records.MonthlyHistoryRecord;

import java.util.Arrays;
import java.util.List;

import org.jooq.Field;
import org.jooq.ForeignKey;
import org.jooq.Index;
import org.jooq.Name;
import org.jooq.Record;
import org.jooq.Row4;
import org.jooq.Schema;
import org.jooq.Table;
import org.jooq.TableField;
import org.jooq.TableOptions;
import org.jooq.UniqueKey;
import org.jooq.impl.DSL;
import org.jooq.impl.SQLDataType;
import org.jooq.impl.TableImpl;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class MonthlyHistory extends TableImpl<MonthlyHistoryRecord> {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>sss.MONTHLY_HISTORY</code>
     */
    public static final MonthlyHistory MONTHLY_HISTORY = new MonthlyHistory();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<MonthlyHistoryRecord> getRecordType() {
        return MonthlyHistoryRecord.class;
    }

    /**
     * The column <code>sss.MONTHLY_HISTORY.ID</code>.
     */
    public final TableField<MonthlyHistoryRecord, String> ID = createField(DSL.name("ID"), SQLDataType.VARCHAR(48).nullable(false), this, "");

    /**
     * The column <code>sss.MONTHLY_HISTORY.CATEGORY_ID</code>.
     */
    public final TableField<MonthlyHistoryRecord, Long> CATEGORY_ID = createField(DSL.name("CATEGORY_ID"), SQLDataType.BIGINT, this, "");

    /**
     * The column <code>sss.MONTHLY_HISTORY.TOTAL</code>.
     */
    public final TableField<MonthlyHistoryRecord, Double> TOTAL = createField(DSL.name("TOTAL"), SQLDataType.DOUBLE, this, "");

    /**
     * The column <code>sss.MONTHLY_HISTORY.DATE</code>.
     */
    public final TableField<MonthlyHistoryRecord, Integer> DATE = createField(DSL.name("DATE"), SQLDataType.INTEGER, this, "");

    private MonthlyHistory(Name alias, Table<MonthlyHistoryRecord> aliased) {
        this(alias, aliased, null);
    }

    private MonthlyHistory(Name alias, Table<MonthlyHistoryRecord> aliased, Field<?>[] parameters) {
        super(alias, null, aliased, parameters, DSL.comment(""), TableOptions.table());
    }

    /**
     * Create an aliased <code>sss.MONTHLY_HISTORY</code> table reference
     */
    public MonthlyHistory(String alias) {
        this(DSL.name(alias), MONTHLY_HISTORY);
    }

    /**
     * Create an aliased <code>sss.MONTHLY_HISTORY</code> table reference
     */
    public MonthlyHistory(Name alias) {
        this(alias, MONTHLY_HISTORY);
    }

    /**
     * Create a <code>sss.MONTHLY_HISTORY</code> table reference
     */
    public MonthlyHistory() {
        this(DSL.name("MONTHLY_HISTORY"), null);
    }

    public <O extends Record> MonthlyHistory(Table<O> child, ForeignKey<O, MonthlyHistoryRecord> key) {
        super(child, key, MONTHLY_HISTORY);
    }

    @Override
    public Schema getSchema() {
        return aliased() ? null : Sss.SSS;
    }

    @Override
    public List<Index> getIndexes() {
        return Arrays.asList(Indexes.MONTHLY_HISTORY_MONTHLY_HISTORY_DATE_IDX);
    }

    @Override
    public UniqueKey<MonthlyHistoryRecord> getPrimaryKey() {
        return Keys.KEY_MONTHLY_HISTORY_PRIMARY;
    }

    @Override
    public List<UniqueKey<MonthlyHistoryRecord>> getUniqueKeys() {
        return Arrays.asList(Keys.KEY_MONTHLY_HISTORY_MONTHLY_HISTORY_UNIQUE_IDX);
    }

    @Override
    public MonthlyHistory as(String alias) {
        return new MonthlyHistory(DSL.name(alias), this);
    }

    @Override
    public MonthlyHistory as(Name alias) {
        return new MonthlyHistory(alias, this);
    }

    /**
     * Rename this table
     */
    @Override
    public MonthlyHistory rename(String name) {
        return new MonthlyHistory(DSL.name(name), null);
    }

    /**
     * Rename this table
     */
    @Override
    public MonthlyHistory rename(Name name) {
        return new MonthlyHistory(name, null);
    }

    // -------------------------------------------------------------------------
    // Row4 type methods
    // -------------------------------------------------------------------------

    @Override
    public Row4<String, Long, Double, Integer> fieldsRow() {
        return (Row4) super.fieldsRow();
    }
}
