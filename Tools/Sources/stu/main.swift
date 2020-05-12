//
//  File.swift
//  
//
//  Created by John McAvey on 5/11/20.
//

import Foundation
import ArgumentParser

public struct Tools: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "tools",
                                                           abstract: "tools for the STU projects",
                                                           subcommands: [Proposals.self])
    public init() {
        
    }
}

// MARK:- Proposals
extension Tools {
    public static var projectRootDirectory: URL {
        URL(fileURLWithPath: #file)
        .deletingLastPathComponent() // Tools/Sources/stu
        .deletingLastPathComponent() // Tools/Sources
        .deletingLastPathComponent() // Tools/
        .deletingLastPathComponent() // /
    }
    public struct Proposals: ParsableCommand {
        public static let configuration = CommandConfiguration(commandName: "proposal",
                                                               abstract: "A tool bundle for proposals lifecycle management",
                                                               subcommands: [New.self])
        public static var proposalsDirectory: URL {
            Tools.projectRootDirectory
                .appendingPathComponent("Proposals") // /Proposals/
        }
        public static var templateFile: URL {
            self.proposalsDirectory
                .appendingPathComponent("Template") // /Proposals/Template
                .appendingPathExtension("md") // /Proposals/Template.md
        }
        
        public static func templateContents() -> Result<String, Error> {
            asResult(try String(contentsOf: Tools.Proposals.templateFile))
        }
        
        public init() {
            
        }
    }
}

extension Tools.Proposals {
    public struct New: ParsableCommand {
        public static var configuration = CommandConfiguration(commandName: "new",
                                                               abstract: "create a new proposal and open it in Xcode.")
        @Argument(help: "The bug number tracking the proposal")
        var bugNumber: Int
        
        @Option(default: "TITLE", help: "The title for the bug")
        var title: String
        
        public init() {
            
        }
        
        public func validate() throws {
            guard bugNumber > 0 else {
                throw ValidationError("The bug number must be greater than 0")
            }
        }
        
        public func run() throws {
            let res = Tools.Proposals.templateContents()
                .map(self.fill)
                .flatMap(self.write)
            try res.throwError()
        }
        
        func fill(template: String) -> String {
            template
            .replacingOccurrences(of: "$NAME", with: self.title)
            .replacingOccurrences(of: "$NUMBER", with: "\(self.bugNumber)")
        }
        
        func destination_url() -> URL {
            Tools.Proposals.proposalsDirectory.appendingPathComponent(self.file_name()).appendingPathExtension("md")
        }
        
        func file_name() -> String {
            return "STU-\(self.bugNumber) \(self.title)"
        }
        
        func write(contents: String) -> Result<URL, Error> {
            do {
                try contents.write(to: self.destination_url(), atomically: false, encoding: .utf8)
                return .success(self.destination_url())
            } catch {
                return .failure(error)
            }
        }
    }
}

func asResult<T>(_ block: @autoclosure () throws -> T) -> Result<T, Error> {
    do {
        return .success(try block())
    } catch {
        return .failure(error)
    }
}

extension Result {
    func throwError() throws {
        switch self {
        case .failure(let err):
            throw err
        default:
            return
        }
    }
}

Tools.main()
