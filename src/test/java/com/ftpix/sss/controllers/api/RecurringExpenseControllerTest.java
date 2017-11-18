package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.RecurringExpense;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

public class RecurringExpenseControllerTest {
    private RecurringExpenseController controller = new RecurringExpenseController();

    @BeforeClass
    public static void prefareDB() throws SQLException {
        PrepareDB.prepareDB();
    }


    @Test
    public void createDeleteRecurringExpense() throws SQLException {

        int count = controller.get().size();

        RecurringExpense expense = controller.create(1, 10d, false, "spotify", RecurringExpense.TYPE_DAILY, 0);

        int newCount = controller.get().size();

        assertEquals(count + 1, newCount);


        assertNotNull(controller.getId(expense.getId()));

        controller.delete(expense.getId());
        newCount = controller.get().size();

        assertEquals(count, newCount);
    }


    @Test(expected = HaltException.class)
    public void testAddingWronCategory() throws SQLException {
        controller.create(3213121, 10d, false, "spotify", RecurringExpense.TYPE_DAILY, 0);
    }

    @Test
    public void testNewDateCalculation(){

        //Daily expense
        RecurringExpense expense = new RecurringExpense();
        expense.setType(RecurringExpense.TYPE_DAILY);

        GregorianCalendar today = new GregorianCalendar();

        GregorianCalendar newDate = new GregorianCalendar();
        newDate.setTime(RecurringExpenseController.calculateNextDate(expense));

        System.out.println(today);
        System.out.println(newDate);

        assertEquals(today.get(Calendar.YEAR), newDate.get(Calendar.YEAR));
        assertEquals(today.get(Calendar.MONTH), newDate.get(Calendar.MONTH));
        assertEquals(today.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));


        //Check monthly of non passed date yet
        GregorianCalendar lastPaymentDate = new GregorianCalendar();
        lastPaymentDate.add(Calendar.YEAR, 1);
        lastPaymentDate.set(Calendar.MONTH, 3);
        lastPaymentDate.set(Calendar.DAY_OF_MONTH, 1);

        expense.setType(RecurringExpense.TYPE_MONTHLY);
        expense.setTypeParam(1);
        expense.setLastOccurrence(lastPaymentDate.getTime());

        newDate.setTime(RecurringExpenseController.calculateNextDate(expense));


        assertEquals(lastPaymentDate.get(Calendar.YEAR), newDate.get(Calendar.YEAR));
        assertEquals(lastPaymentDate.get(Calendar.MONTH) + 1, newDate.get(Calendar.MONTH));
        assertEquals(lastPaymentDate.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));


        //Check yearly of non passed date yet
        lastPaymentDate = new GregorianCalendar();
        lastPaymentDate.add(Calendar.YEAR, 1);
        lastPaymentDate.set(Calendar.MONTH, 3);
        lastPaymentDate.set(Calendar.DAY_OF_MONTH, 1);

        expense.setType(RecurringExpense.TYPE_YEARLY);
        expense.setTypeParam(3);
        expense.setLastOccurrence(lastPaymentDate.getTime());

        newDate.setTime(RecurringExpenseController.calculateNextDate(expense));


        assertEquals(lastPaymentDate.get(Calendar.YEAR) +1, newDate.get(Calendar.YEAR));
        assertEquals(lastPaymentDate.get(Calendar.MONTH), newDate.get(Calendar.MONTH));
        assertEquals(lastPaymentDate.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));


    }


}
