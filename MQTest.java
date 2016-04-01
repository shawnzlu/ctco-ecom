package aaMQtest;

import com.ibm.mq.MQC;
import com.ibm.mq.MQException;
import com.ibm.mq.MQQueue;
import com.ibm.mq.MQQueueManager;
import com.ibm.msg.client.wmq.v6.base.internal.MQPutMessageOptions;

import java.util.Hashtable;

public class MQTest {

    public static void main(String[] args) throws MQException {
        int openOptions = MQC.MQOO_OUTPUT | MQC.MQOO_FAIL_IF_QUIESCING;
        Hashtable table = new Hashtable();
        table.put(MQC.HOST_NAME_PROPERTY, "42.120.113.126");
        table.put(MQC.CHANNEL_PROPERTY, "QM.DEVELOP.CONN");
        MQQueueManager mqMgr = new MQQueueManager("QM_DEVELOP", table);
        MQPutMessageOptions mqMsgOpt = new MQPutMessageOptions();
        MQQueue mqPutQ = mqMgr.accessQueue("MINI.MX.SIT.REQ", openOptions, null, null, null);
        System.out.println("Connected to Q:" + "MINI.MX.SIT.REQ");
//        MQQueue mqPutQ = mqMgr.accessQueue("CREATE.EQUITY.ORDER", openOptions, null, null, null);
//        System.out.println("Connected to Q:" + "CREATE.EQUITY.ORDER");
    }

}