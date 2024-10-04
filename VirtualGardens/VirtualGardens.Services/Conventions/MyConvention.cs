using EasyNetQ;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VirtualGardens.Services.Conventions
{
    public class MyConvention : EasyNetQ.Conventions
    {
        public MyConvention(ITypeNameSerializer typeNameSerializer) : base(typeNameSerializer) 
        {
            ErrorQueueNamingConvention = messageInfo => "MyErrorQueue";
        }
    }
}
