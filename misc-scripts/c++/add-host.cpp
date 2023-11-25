#include <ios>
#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <vector>
#include <algorithm>
#include <filesystem>
#include <boost/algorithm/string.hpp>
#include <boost/algorithm/string/join.hpp>

const std::regex re("[-_a-z0-9]+(\\.[-_a-z0-9]+)+");

class Url
{
private:
    std::string host;

public:
    Url(const std::string &url)
    {
        try
        {
            std::smatch match;

            if (std::regex_search(url, match, re) && match.size() > 1)
            {
                host = match.str(0);
            }
            else
            {
                throw std::invalid_argument(url);
            }
        }
        catch (std::regex_error &e)
        {
            std::cerr << e.what() << std::endl;
        }
        catch (std::invalid_argument &e)
        {
            std::cerr << "\"" << e.what() << "\" is an invalid argument" << std::endl;
        }
    }

    std::string reverse() const
    {
        std::vector<std::string> v;
        boost::split(v, host, [](char c) { return c == '.'; });
        std::reverse(v.begin(), v.end());
        return boost::algorithm::join(v, ".");
    }

    const std::string &getHost() const
    {
        return host;
    }

    const Url &operator=(const Url &url)
    {
        host = url.host;
        return *this;
    }

    friend bool operator==(const Url &url1, const Url &url2);
    friend bool operator<(const Url &url1, const Url &url2);
    friend std::ostream &operator<<(std::ostream &os, const Url &url);
};

bool operator==(const Url &url1, const Url &url2)
{
    return url1.host == url2.host;
}

bool operator<(const Url &url1, const Url &url2)
{
    return url1.reverse() < url2.reverse();
}

std::ostream &operator<<(std::ostream &os, const Url &url)
{
    os << url.host;
    return os;
}

int main(int argc, char *argv[])
{
    const std::string hosts_name = "/root/etc/hosts";
    const std::string hosts_head_name = "/root/etc/hosts-head";
    const std::string hosts_tail_name = "/root/etc/hosts-tail";
    std::ofstream hosts(hosts_name, std::ios_base::trunc);
    std::ifstream hosts_head(hosts_head_name);
    bool ok = true;

    if (hosts_head.is_open())
    {
        hosts << hosts_head.rdbuf();
        hosts_head.close();

        std::string str;
        std::vector<Url> v;
        std::ifstream hosts_tail_in(hosts_tail_name);

        while (std::getline(hosts_tail_in, str))
        {
            if (str.size() > 0)
            {
                v.push_back(str);
            }
        }

        hosts_tail_in.close();

        str = argv[1];
        Url url(str);

        if (std::find(v.begin(), v.end(), url) == v.end())
        {
            if (system((std::string("ping -c 1 " + url.getHost())).c_str()) != 0)
            {
                std::cout << "Could not ping " << url << "; Add anyway (y/N)? ";
                std::getline(std::cin, str);
                ok = str.size() > 0 && (str == "y" || str == "Y");
            }

            if (ok)
            {
                v.push_back(url);
                std::sort(v.begin(), v.end());
                std::ofstream hosts_tail_out(hosts_tail_name, std::ios_base::trunc);

                for (Url url : v)
                {
                    hosts_tail_out << url << std::endl;
                }

                hosts_tail_out.close();
            }
        }
        else
        {
            ok = false;
        }

        for (Url url : v)
        {
            hosts << "127.0.0.1\t" << url << std::endl;
        }

        hosts.close();
    }

    if (ok)
    {
        std::filesystem::copy(hosts_name, "/etc/hosts", std::filesystem::copy_options::update_existing);
        Url url(argv[1]);
        std::cout << "Added \"127.0.0.1\t" << url << "\" to file " << hosts_name << std::endl;
    }

    return 0;
}