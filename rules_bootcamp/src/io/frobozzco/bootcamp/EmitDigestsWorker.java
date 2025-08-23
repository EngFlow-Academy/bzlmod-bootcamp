// Copyright 2025 EngFlow, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package io.frobozzco.bootcamp;

import com.google.devtools.build.lib.worker.WorkerProtocol.Input;
import com.google.devtools.build.lib.worker.WorkerProtocol.WorkRequest;
import com.google.devtools.build.lib.worker.WorkerProtocol.WorkResponse;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.lang.FunctionalInterface;
import java.util.stream.Stream;

public final class EmitDigestsWorker {
    public static void main(String[] args) {
        final boolean persistent = (
            args.length != 0 && args[0] != "--persistent_worker");

        while (handleRequest(EmitDigestsWorker::emitDigestsFile) && persistent);
    }

    @FunctionalInterface
    public interface RequestConsumer {
        public void accept(WorkRequest request) throws IOException;
    }

    public static boolean handleRequest(RequestConsumer consumer) {
        try {
            WorkRequest request = WorkRequest.parseDelimitedFrom(System.in);

            if (request == null) {
                return false;
            }
            consumer.accept(request);

            WorkResponse.newBuilder()
                .setRequestId(request.getRequestId())
                .setExitCode(0)
                .build()
                .writeDelimitedTo(System.out);
            return true;

        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void emitDigestsFile(WorkRequest request) throws IOException {
        String outFile = request.getArgumentsList().get(0);
        Stream<Input> inputs = request.getInputsList()
            .stream()
            .sorted((lhs, rhs) -> lhs.getPath().compareTo(rhs.getPath()));

        try (FileOutputStream f = new FileOutputStream(outFile);
            PrintStream outStream = new PrintStream(f)) {
            inputs.forEachOrdered(i -> outStream.printf(
                "%s %s\n", i.getDigest().toStringUtf8(), i.getPath()));
        }
    }
}
